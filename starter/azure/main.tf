data "azurerm_resource_group" "udacity" {
  name     = "Regroup_1nzJP2paiTclv7j7nTdm"
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
    image  = "docker.io/tscotto5/azure_app:1.0"
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

resource "azurerm_mssql_server" "udacity" {
  name                         = "saksjain-sqlserver"
  resource_group_name          = data.azurerm_resource_group.udacity.name
  location                     = data.azurerm_resource_group.udacity.location
  version                      = "12.0"
  administrator_login          = "student_10f0d9bbleu93ob7_001544326@vocareumvocareum.onmicrosoft.com"
  administrator_login_password = "1OUlnuYNDAEhsA8MgIjBP?TuauahvTONfoPMJ#rEQ5F0wqx"
}

data "azurerm_client_config" "current" {}

# Dotnet web app
resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_resource_group.udacity.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "example" {
  name                = "saksjainwebapp"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_resource_group.udacity.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}
