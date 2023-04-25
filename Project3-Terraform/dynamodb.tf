resource "aws_dynamodb_table" "db_table" {
  name           = "snakehighscore"
  billing_mode   = "PROVISIONED"
  read_capacity  = "5"
  write_capacity = "5"
  hash_key       = "playername"
  range_key      = "highscore"

  attribute {
    name = "playername"
    type = "S"
  }
  attribute {
    name = "highscore"
    type = "N"
  }


}

#Primary Key: player_name   Sort Key: high_score


# global_secondary_index {
#     name               = "GameTitleIndex"
#     hash_key           = "GameTitle"
#     range_key          = "TopScore"
#     write_capacity     = 10
#     read_capacity      = 10
#     projection_type    = "INCLUDE"
#     non_key_attributes = ["UserId"]
#   }

#   tags = {
#     Name        = "dynamodb-table-1"
#     Environment = "production"
#   }
# }

# # #provisioning
# # resource "aws_dynamodb_table" "tf_notes_table" {
# #  // prior configuration...

# #  // adding the TTL on existing Table
# #  ttl {
# #  // enabling TTL
# #   enabled = true 

# #   // the attribute name which enforces  TTL, must be a Number      (Timestamp)
# #   attribute_name = "expiryPeriod" 
# #  }
# # }

# # #encrypting
# # resource "aws_dynamodb_table" "tf_notes_table" {
# #  // other table configuration
# #  // configure encryption at REST
# #  server_side_encryption {
# #    enabled = true 
# #    // false -> use AWS Owned CMK 
# #    // true -> use AWS Managed CMK 
# #    // true + key arn -> use custom key
# #   }
# # }
