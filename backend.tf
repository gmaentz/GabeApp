terraform {
  backend "remote" {
    organization = "RPTData"

    workspaces {
      name = "GabeApp-DEV"
    }
  }
}

