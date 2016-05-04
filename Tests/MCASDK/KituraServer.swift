/*
import Foundation
import Kitura
import KituraNet
import KituraSys
import SwiftyJSON
import SimpleLogger
import MobileClientAccessSDK

public class KituraServer {
	private let logger = Logger(forName:"KituraServer")
	private var router = Router()
	private var server:HttpServer?
	
	public func start(onPort port:Int){
		logger.info("Staring on port " + String(port))
		//TODO: i think this only supports one middleware
		//        app.middleware.removeLast()
		//        app.middleware.append(MCAKituraMiddleware(hash: app.hash))
		router.all(middleware: MCAKituraMiddleware())
		router.all("/public", handler: { (request, response, next) in
			response.status(.OK).send("Hello from a public resource!")
			next()
		})
		router.all("/protected", handler: { (request, response, next) in
			response.status(response.statusCode)
			next()
		})
		server = HttpServer.listen(port: port, delegate: router)
		Server.run()
	}
	
	public func stop(){
		if let server = server{
			server.stop()
		}
	}
}

*/