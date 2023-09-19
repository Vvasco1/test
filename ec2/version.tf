terraform {
 # 현 테라폼 버전에 적용되도록 구성
  required_version = ">=1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# AWS 공급자 구성
provider "aws" {
  region  = "ap-northeast-2" # 서울 리전
}
