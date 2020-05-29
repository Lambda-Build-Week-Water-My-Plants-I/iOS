//
//  testJSON.swift
//  Water My PlantsUITests
//
//  Created by Ezra Black on 5/29/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation

//Shape of User Required to Register (JSON):
let validUserJSON = """
{
  "username": "BrandonSanderson",
  "password": "AuthorMan2020",
  "phone_number": "1234567890"
}
""".data(using: .utf8)!

//Broken Shape of User Required to Register (JSON):
let invalidUserJSON = """
{
  "username": "BrandonSanderson",
  "password "AuhorMan2020",
  "phoneer": "12345690"
}
""".data(using: .utf8)!

//The Data Returned by Server After Registering:
let validRegisteredReturnData = """
{
    "id": 1,
    "username": "BrandonSanderson",
    "phone_number": "1234567890"
}
""".data(using: .utf8)

//Broken Data Returned by Server After Registering:
let invalidRegisteredReturnData = """
{
    "id,
    "userandonSanderson",
    "phone_number": "1234567890"
}
""".data(using: .utf8)

//Shape of User Required to Login (JSON):
let validDataSentToLogin = """
{
  "username": "BrandonSanderson",
  "password": "AuthorMan2020"
}
""".data(using: .utf8)

//Broken Shape of User Required to Login (JSON):
let invalidDataSentToLogin = """
{
  "username": "BrandonSanderson",
  "password": "AuthorMan2020"
}
""".data(using: .utf8)

//The Data Returned by Server After Logging In:
let validDataReturnedByLogin = """
{
    "id": 1,
    "welcome": "BrandonSanderson",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwidXNlcm5hbWUiOiJwZXRlcnBhbiIsImlhdCI6MTU5MDUyMzgwNSwiZXhwIjoxNTkwNTQxODA1fQ.J7xBHz_ZbPQDkVIai3kA3XvdYM0akrI2LqqBq9FzeFk"
}
""".data(using: .utf8)

//The Data Returned by Server After Logging In:
let invalidDataReturnedByLogin = """
{
    "ie": "BrandonSanderson",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OCwidXNlcm5hbWUiOiJwZXRlcnBhbiIsImlhdCI6MTU5MDUyMzgwNSwiZXhwIjoxNTkwNTQxODA1fQ.J7xBHz_ZbPQDkVIai3kA3XvdYM0akrI2LqqBq9FzeFk"
}
""".data(using: .utf8)
