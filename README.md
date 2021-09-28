# AWS Dynamo DB Table

Simple terraform module for creation of a dynamo DB 
table with autoscaling and support for secondary indexes.

## Usage

Simple table:

```hcl
module "users" {
  source = "git@github.com:com:kuffel/aws-dynamodb-table.git"
  table_name = "users"
  table_hash_key = "uuid"
  table_hash_key_type = "S"
}
```

Table with secondary indexes:

```hcl
module "users" {
  source = "git@github.com:com:kuffel/aws-dynamodb-table.git"

  table_name = "dev-users"
  table_hash_key = "uuid"
  table_hash_key_type = "S"

  global_secondary_indexes = {
    "name" = {
      type = "S"
    }
    "email" = {
      type = "S"
    }
  }
}
```

## Variables

See `variables.tf` for all available configuration options.