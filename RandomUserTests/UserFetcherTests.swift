//
//  UserFetcherTests.swift
//  RandomUserTests
//
//  Created by Haoming Ma on 16/11/19.
//  Copyright © 2019 Haoming. All rights reserved.
//

import XCTest
import Combine
import EntwineTest

@testable import RandomUser


class UserFetcherTests: XCTestCase {
    
    private let seed = "abc"
    
    private let fetcher = RandomUser.UserFetcher()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDecode() {
        let testScheduler = TestScheduler(initialClock: 0)
        
        let decodedUserPublisher: AnyPublisher<RandomUser.RandomUserApiResponse, RandomUser.RandomUserError> = RandomUser.UserFetcher.decode(self.threeUsersResponse)
        
        let result = testScheduler.start{ decodedUserPublisher }.recordedOutput[1].1
        
        switch result {
        case .input(let apiResponse):
            XCTAssertEqual(nil, apiResponse.error)
            XCTAssertEqual(1, apiResponse.info!.page)
            XCTAssertEqual(3, apiResponse.info!.results)
            XCTAssertEqual(self.seed, apiResponse.info!.seed)
            
            let user0 = apiResponse.results![0]
            let user1 = apiResponse.results![1]
            let user2 = apiResponse.results![2]
            
            XCTAssertEqual("Louane", user0.name!.first!)
            XCTAssertEqual("Vidal", user0.name!.last!)
            XCTAssertEqual("female", user0.gender!)
            XCTAssertEqual("louane.vidal@example.com", user0.email!)
            
            XCTAssertEqual("don.white@example.com", user1.email!)
            XCTAssertEqual("loan.lucas@example.com", user2.email!)
        default:
            XCTFail()
        }
    }

}


extension UserFetcherTests {
    var threeUsersResponse: Data {
        get {
            let response = """
                {
                  "results": [
                    {
                      "gender": "female",
                      "name": {
                        "title": "Miss",
                        "first": "Louane",
                        "last": "Vidal"
                      },
                      "location": {
                        "street": {
                          "number": 2479,
                          "name": "Place du 8 Février 1962"
                        },
                        "city": "Avignon",
                        "state": "Vendée",
                        "country": "France",
                        "postcode": 78276,
                        "coordinates": {
                          "latitude": "2.0565",
                          "longitude": "95.2422"
                        },
                        "timezone": {
                          "offset": "+1:00",
                          "description": "Brussels, Copenhagen, Madrid, Paris"
                        }
                      },
                      "email": "louane.vidal@example.com",
                      "login": {
                        "uuid": "9f07341f-c7e6-45b7-bab0-af6de5a4582d",
                        "username": "angryostrich988",
                        "password": "r2d2",
                        "salt": "B5ywSDUM",
                        "md5": "afce5fbe8f32bcec1a918f75617ab654",
                        "sha1": "1a5b1afa1d9913cf491af64ce78946d18fea6b04",
                        "sha256": "0124895aa1e6e5fb0596fad4c413602e0922e8a8c2dc758bbdb3fa070ad25a07"
                      },
                      "dob": {
                        "date": "1966-06-26T11:50:25.558Z",
                        "age": 53
                      },
                      "registered": {
                        "date": "2016-08-11T06:51:52.086Z",
                        "age": 3
                      },
                      "phone": "02-62-35-18-98",
                      "cell": "06-07-80-83-11",
                      "id": {
                        "name": "INSEE",
                        "value": "2NNaN01776236 16"
                      },
                      "picture": {
                        "large": "https://randomuser.me/api/portraits/women/88.jpg",
                        "medium": "https://randomuser.me/api/portraits/med/women/88.jpg",
                        "thumbnail": "https://randomuser.me/api/portraits/thumb/women/88.jpg"
                      },
                      "nat": "FR"
                    },
                    {
                      "gender": "male",
                      "name": {
                        "title": "Mr",
                        "first": "Don",
                        "last": "White"
                      },
                      "location": {
                        "street": {
                          "number": 4542,
                          "name": "Rochestown Road"
                        },
                        "city": "Sallins",
                        "state": "Monaghan",
                        "country": "Ireland",
                        "postcode": 44584,
                        "coordinates": {
                          "latitude": "89.4367",
                          "longitude": "135.6354"
                        },
                        "timezone": {
                          "offset": "+11:00",
                          "description": "Magadan, Solomon Islands, New Caledonia"
                        }
                      },
                      "email": "don.white@example.com",
                      "login": {
                        "uuid": "1cd1e622-12bb-4b35-a2c9-63ff7bda6c73",
                        "username": "angryduck156",
                        "password": "0101",
                        "salt": "XDlG0rRr",
                        "md5": "35e6f5e0247d43f6dec0056c8317f320",
                        "sha1": "ee6a3affc22de617283eb28e8df7fab72b153052",
                        "sha256": "6cf456410cf19343336972d23d00d0884fed29c3e73a5584aeae2eeda3a48758"
                      },
                      "dob": {
                        "date": "1949-10-09T00:25:51.304Z",
                        "age": 70
                      },
                      "registered": {
                        "date": "2017-06-06T09:27:25.706Z",
                        "age": 2
                      },
                      "phone": "051-441-5241",
                      "cell": "081-956-4429",
                      "id": {
                        "name": "PPS",
                        "value": "5081227T"
                      },
                      "picture": {
                        "large": "https://randomuser.me/api/portraits/men/38.jpg",
                        "medium": "https://randomuser.me/api/portraits/med/men/38.jpg",
                        "thumbnail": "https://randomuser.me/api/portraits/thumb/men/38.jpg"
                      },
                      "nat": "IE"
                    },
                    {
                      "gender": "male",
                      "name": {
                        "title": "Mr",
                        "first": "Loan",
                        "last": "Lucas"
                      },
                      "location": {
                        "street": {
                          "number": 2256,
                          "name": "Place de L'Église"
                        },
                        "city": "Argenteuil",
                        "state": "Lot-et-Garonne",
                        "country": "France",
                        "postcode": 87662,
                        "coordinates": {
                          "latitude": "3.9825",
                          "longitude": "176.6213"
                        },
                        "timezone": {
                          "offset": "+7:00",
                          "description": "Bangkok, Hanoi, Jakarta"
                        }
                      },
                      "email": "loan.lucas@example.com",
                      "login": {
                        "uuid": "4b400301-d696-4618-862e-8a673f80e334",
                        "username": "orangepanda844",
                        "password": "wonderboy",
                        "salt": "iHPZA8UP",
                        "md5": "97eca8070d96e8e27b1c468e9cb3fd9e",
                        "sha1": "23c5a9a09387d4d9b381c5f86330a1629971a7fa",
                        "sha256": "817b0ddb16a74507134956bcd0e80467e5efbcc309116bf3caf98199b6c54e59"
                      },
                      "dob": {
                        "date": "1992-11-21T06:28:32.563Z",
                        "age": 27
                      },
                      "registered": {
                        "date": "2007-10-22T21:15:52.757Z",
                        "age": 12
                      },
                      "phone": "04-56-18-88-34",
                      "cell": "06-74-93-14-75",
                      "id": {
                        "name": "INSEE",
                        "value": "1NNaN18631077 64"
                      },
                      "picture": {
                        "large": "https://randomuser.me/api/portraits/men/3.jpg",
                        "medium": "https://randomuser.me/api/portraits/med/men/3.jpg",
                        "thumbnail": "https://randomuser.me/api/portraits/thumb/men/3.jpg"
                      },
                      "nat": "FR"
                    }
                  ],
                  "info": {
                    "seed": "abc",
                    "results": 3,
                    "page": 1,
                    "version": "1.3"
                  }
                }
            """
            
            return response.data(using: .utf8)!
        }
    }
}
