//
//  Account.swift
//
//
//  Created by Phucnh on 10/15/20.
//

import App
import Vapor
import Smtp

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }

app.smtp.configuration.hostname = "smtp.gmail.com"
app.smtp.configuration.username = "nguyenhongphuc98@gmail.com"
app.smtp.configuration.password = "01666272703aaaa"
app.smtp.configuration.secure = .ssl

try configure(app)
try app.run()
