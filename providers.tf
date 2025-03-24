provider "aws" {
  alias      = "east"
  region     = var.region_east
}

provider "aws" {
  alias      = "west"
  region     = var.region_west
}

