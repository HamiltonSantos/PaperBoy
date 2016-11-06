//
//  GameControllerManager.swift
//  TVCommunication
//
//  Created by Gabriel Caron  on 02/06/16.
//  Copyright © 2016 Gabriel Caron. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class GameControllerManager: NSObject, GCDAsyncSocketDelegate, NetServiceDelegate {

    //MARK: Properties
    var service: NetService!
    var socket: GCDAsyncSocket!
    var clientSockets: NSMutableArray!
    var delegate: GameControllerManagerDelegate?
    let serviceType = "_paperBoyMultiplayer"
    let serviceProtocol = "_tcp"

    override init() {
        super.init()
        startBroadcast()
    }

    //MARK: Configuration

    func startBroadcast() {
        //Initialize socket
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global())
        clientSockets = NSMutableArray()

        //Start Listening
        guard (try? self.socket.accept(onPort: 0)) != nil else {
            print("Unable to create socket")
            return
        }

        //Initialize Service
        let localPort = self.socket.localPort
        service = NetService(domain: "local", type: "\(serviceType).\(serviceProtocol)", name: "PaperBoyMultiplayer", port: Int32(localPort))
        service.delegate = self
        service.publish()
    }

    //MARK: NSNetService Delegates

    func netServiceDidPublish(_ sender: NetService) {

        print("Bonjour service published: domain\(service.domain) type:\(service.type) name:\(service.name) port:\(service.port)")
    }

    private func netService(sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Failed to publish service: domain\(service.domain) type:\(service.type) name:\(service.name) port:\(service.port)")
        print(errorDict)
    }

    //MARK: Socket Delegates

    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        print("Accepted new socket from \(newSocket.connectedHost) \(newSocket.connectedPort)")
        newSocket.delegate = self
        clientSockets.add(newSocket)
        newSocket.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1, tag: 0)

        //OBS.: talvez seja preciso mudar a id
        var id: Int = clientSockets.count-1
        let data = NSData(bytes: &id, length: MemoryLayout<Int>.size)
        newSocket.write(data as Data, withTimeout: -1, tag: 0)
        delegate?.playerDidConnect(player: id)
    }

    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {

        print("Socket disconnected: host - \(sock.connectedHost) port - \(sock.connectedPort)")
        for i in 0..<clientSockets.count {

            //Crasha aqui ao desconectar
            let s = clientSockets.object(at: i) as! GCDAsyncSocket
            if sock == s {
                clientSockets.remove(sock)
                delegate?.playerDidDisconnect(player: i)
            }
        }
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {

        //TODO - separar o didReceiveData e o didReceiveCommand
        let playerIdData = data.subdata(in: Range(uncheckedBounds: (0,MemoryLayout<Int16>.size)))
        let playerData = data.subdata(in: Range(uncheckedBounds: (MemoryLayout<Int16>.size, data.count - MemoryLayout<Int16>.size)))

        var id = [UInt8](repeating:0, count:data.count)
        playerIdData.copyBytes(to: &id, count: MemoryLayout<Int>.size)
        var commandInt = [UInt8](repeating:0, count:data.count)
        playerData.copyBytes(to: &commandInt, count: MemoryLayout<Int>.size)
        print("Player id is: \(id)")
        print("Player command Int is: \(commandInt)")

        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            if Int(commandInt[0]) >= CommandType.Data.hashValue {
                self.delegate?.didReceiveData(fromPlayer: Int(id[0]), data: data as NSData)
            } else {
//                self.delegate?.didReceiveCommand(fromPlayer: id, command: CommandType(rawValue: commandInt)!)
            }
        }
        sock.readData(toLength: UInt(data.count), withTimeout: -1, tag: 0)
    }

    //MARK: Communication methods

    func sendDataToPlayer(player: Int, data: NSData) {

        let sock = clientSockets.object(at: player) as! GCDAsyncSocket
        sock.write(data as Data, withTimeout: -1, tag: 0)
    }

    func sendDataToAllPlayers(data: NSData) {

        if clientSockets.count == 0 {return}

        for i in 0..<clientSockets.count {
            sendDataToPlayer(player: i, data: data)
        }
    }

    func sendCommandToPlayer(player: Int, command: CommandType) {
        var commandInt = command.hashValue
        let data = NSData(bytes: &commandInt, length: MemoryLayout<Int64>.size)
        sendDataToPlayer(player: player, data: data)
    }

    func sendCommandToAllPlayers(command: CommandType) {
        var commandInt = command.hashValue
        let data = NSData(bytes: &commandInt, length: MemoryLayout<Int64>.size)
        sendDataToAllPlayers(data: data)
    }
}

public protocol GameControllerManagerDelegate {

    func didReceiveData(fromPlayer player: Int, data: NSData)
    func didReceiveSpeed(fromPlayer player: Int, speed: Float)
    func playerDidConnect(player: Int)
    func playerDidDisconnect(player: Int)
//    func didSendData(toPlayer player: GCDAsyncSocket)
//    func didSendData(toAllPlayers players: NSMutableArray)
}

public enum CommandType: Int {
    case Up, Down, Left, Right, Action1, Action2, GameInit, Data
}
