data "azurerm_resource_group" "udacity" {
  name     = "Regroup_1iVpmoBEoV39VmCVmM6VJ"
}

resource "azurerm_container_group" "udacity" {
  name                = "udacity-continst"
  location            = data.azurerm_resource_group.udacity.location
  resource_group_name = data.azurerm_resource_group.udacity.name
  ip_address_type     = "Public"
  dns_name_label      = "udacity-sakshee-azure"
  os_type             = "Linux"

  container {
    name   = "azure-container-app"
    image  = "docker.io/sakshee5/azure_app:1.0"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
      "AWS_S3_BUCKET"       = "my-sakshee-bucket",
      "AWS_DYNAMO_INSTANCE" = "GameScores"
    }
    ports {
      port     = 3000
      protocol = "TCP"
    }
  }
  tags = {
    environment = "udacity"
  }
}

####### Your Additions Will Start Here ######

data "azurerm_cosmosdb_account" "udacity" {
  name                = "udacitysaks"
  resource_group_name = data.azurerm_resource_group.udacity.name
}

resource "azurerm_mssql_server" "example" {
  name                         = "example-sqlserver"
  resource_group_name          = data.azurerm_resource_group.udacity.name
  location                     = data.azurerm_resource_group.udacity.location
  version                      = "12.0"
  administrator_login          = "student_10f0d9bbleu93ob7_001544326@vocareumvocareum.onmicrosoft.com"
  administrator_login_password = "1OUlnuYNDAEhsA8MgIjBP?TuauahvTONfoPMJ#rEQ5F0wqx"
}

resource "azurerm_cosmosdb_sql_database" "udacity" {
  name                = "jain-cosmos-sql-db"
  resource_group_name = data.azurerm_resource_group.udacity.name
  account_name        = data.azurerm_cosmosdb_account.udacity.name
  throughput          = 400
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "udacity" {
  name     = data.azurerm_resource_group.udacity.name
  location = "West Europe"
}

resource "azurerm_bot_web_app" "udacity" {
  name                = "udacity"
  location            = "global"
  resource_group_name = data.azurerm_resource_group.udacity.name
  sku                 = "F0"
  microsoft_app_id    = data.azurerm_client_config.current.client_id
}
