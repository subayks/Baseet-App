//
//  ProDuctDetailsModel.swift
//  Baseet App
//
//  Created by Subendran on 06/08/22.
//


import Foundation

struct ProDuctDetailsModel: Codable {

  var id                    : Int?           = nil
  var name                  : String?        = nil
  var appimage              : String?        = nil
  var description           : String?        = nil
  var image                 : String?        = nil
  var categoryId            : Int?           = nil
  var categoryIds           : [CategoryIds]? = []
  var variations            : [String]?      = []
  var addOns                : [AddOns]?      = []
  var attributes            : [String]?      = []
  var choiceOptions         : [String]?      = []
  var price                 : Int?           = nil
  var tax                   : Int?           = nil
  var taxType               : String?        = nil
  var discount              : Int?           = nil
  var discountType          : String?        = nil
  var availableTimeStarts   : String?        = nil
  var availableTimeEnds     : String?        = nil
  var veg                   : Int?           = nil
  var status                : Int?           = nil
  var restaurantId          : Int?           = nil
  var createdAt             : String?        = nil
  var updatedAt             : String?        = nil
  var orderCount            : String?        = nil
  var avgRating             : Int?           = nil
  var ratingCount           : Int?           = nil
  var restaurantName        : String?        = nil
  var restaurantDiscount    : Int?           = nil
  var restaurantOpeningTime : String?        = nil
  var restaurantClosingTime : String?        = nil
  var scheduleOrder         : Bool?          = nil

  enum CodingKeys: String, CodingKey {

    case id                    = "id"
    case name                  = "name"
    case appimage              = "appimage"
    case description           = "description"
    case image                 = "image"
    case categoryId            = "category_id"
    case categoryIds           = "category_ids"
    case variations            = "variations"
    case addOns                = "add_ons"
    case attributes            = "attributes"
    case choiceOptions         = "choice_options"
    case price                 = "price"
    case tax                   = "tax"
    case taxType               = "tax_type"
    case discount              = "discount"
    case discountType          = "discount_type"
    case availableTimeStarts   = "available_time_starts"
    case availableTimeEnds     = "available_time_ends"
    case veg                   = "veg"
    case status                = "status"
    case restaurantId          = "restaurant_id"
    case createdAt             = "created_at"
    case updatedAt             = "updated_at"
    case orderCount            = "order_count"
    case avgRating             = "avg_rating"
    case ratingCount           = "rating_count"
    case restaurantName        = "restaurant_name"
    case restaurantDiscount    = "restaurant_discount"
    case restaurantOpeningTime = "restaurant_opening_time"
    case restaurantClosingTime = "restaurant_closing_time"
    case scheduleOrder         = "schedule_order"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id                    = try values.decodeIfPresent(Int.self           , forKey: .id                    )
    name                  = try values.decodeIfPresent(String.self        , forKey: .name                  )
    appimage              = try values.decodeIfPresent(String.self        , forKey: .appimage              )
    description           = try values.decodeIfPresent(String.self        , forKey: .description           )
    image                 = try values.decodeIfPresent(String.self        , forKey: .image                 )
    categoryId            = try values.decodeIfPresent(Int.self           , forKey: .categoryId            )
    categoryIds           = try values.decodeIfPresent([CategoryIds].self , forKey: .categoryIds           )
    variations            = try values.decodeIfPresent([String].self      , forKey: .variations            )
    addOns                = try values.decodeIfPresent([AddOns].self      , forKey: .addOns                )
    attributes            = try values.decodeIfPresent([String].self      , forKey: .attributes            )
    choiceOptions         = try values.decodeIfPresent([String].self      , forKey: .choiceOptions         )
    price                 = try values.decodeIfPresent(Int.self           , forKey: .price                 )
    tax                   = try values.decodeIfPresent(Int.self           , forKey: .tax                   )
    taxType               = try values.decodeIfPresent(String.self        , forKey: .taxType               )
    discount              = try values.decodeIfPresent(Int.self           , forKey: .discount              )
    discountType          = try values.decodeIfPresent(String.self        , forKey: .discountType          )
    availableTimeStarts   = try values.decodeIfPresent(String.self        , forKey: .availableTimeStarts   )
    availableTimeEnds     = try values.decodeIfPresent(String.self        , forKey: .availableTimeEnds     )
    veg                   = try values.decodeIfPresent(Int.self           , forKey: .veg                   )
    status                = try values.decodeIfPresent(Int.self           , forKey: .status                )
    restaurantId          = try values.decodeIfPresent(Int.self           , forKey: .restaurantId          )
    createdAt             = try values.decodeIfPresent(String.self        , forKey: .createdAt             )
    updatedAt             = try values.decodeIfPresent(String.self        , forKey: .updatedAt             )
    orderCount            = try values.decodeIfPresent(String.self        , forKey: .orderCount            )
    avgRating             = try values.decodeIfPresent(Int.self           , forKey: .avgRating             )
    ratingCount           = try values.decodeIfPresent(Int.self           , forKey: .ratingCount           )
    restaurantName        = try values.decodeIfPresent(String.self        , forKey: .restaurantName        )
    restaurantDiscount    = try values.decodeIfPresent(Int.self           , forKey: .restaurantDiscount    )
    restaurantOpeningTime = try values.decodeIfPresent(String.self        , forKey: .restaurantOpeningTime )
    restaurantClosingTime = try values.decodeIfPresent(String.self        , forKey: .restaurantClosingTime )
    scheduleOrder         = try values.decodeIfPresent(Bool.self          , forKey: .scheduleOrder         )
 
  }

  init() {

  }

}

struct AddOns: Codable {

  var id           : Int?    = nil
  var name         : String? = nil
  var price        : Int?    = nil
  var createdAt    : String? = nil
  var updatedAt    : String? = nil
  var restaurantId : Int?    = nil
  var status       : Int?    = nil

  enum CodingKeys: String, CodingKey {

    case id           = "id"
    case name         = "name"
    case price        = "price"
    case createdAt    = "created_at"
    case updatedAt    = "updated_at"
    case restaurantId = "restaurant_id"
    case status       = "status"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id           = try values.decodeIfPresent(Int.self    , forKey: .id           )
    name         = try values.decodeIfPresent(String.self , forKey: .name         )
    price        = try values.decodeIfPresent(Int.self    , forKey: .price        )
    createdAt    = try values.decodeIfPresent(String.self , forKey: .createdAt    )
    updatedAt    = try values.decodeIfPresent(String.self , forKey: .updatedAt    )
    restaurantId = try values.decodeIfPresent(Int.self    , forKey: .restaurantId )
    status       = try values.decodeIfPresent(Int.self    , forKey: .status       )
 
  }

  init() {

  }

}

struct CategoryIds: Codable {

  var id       : String? = nil
  var position : Int?    = nil

  enum CodingKeys: String, CodingKey {

    case id       = "id"
    case position = "position"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id       = try values.decodeIfPresent(String.self , forKey: .id       )
    position = try values.decodeIfPresent(Int.self    , forKey: .position )
 
  }

  init() {

  }

}


