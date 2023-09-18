#VPC
resource "aws_vpc" "test" {
  cidr_block           = "10.0.0.0/16" # 임의 지정
  instance_tenancy     = "default" # 인스턴스에 대한 테넌트 옵션 기본값
  tags = {
    Name = "TEST-VPC"
  }
}

#EIP for NAT
resource "aws_eip" "nat" {
  tags = {
    Name = "test-eip-nat"
  }
}

#Internet GW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test.id
  tags = {
    Name = "test-igw"
  }
}

#NAT GW
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id # 퍼블릭 연결을 위한 EIP
  subnet_id     = aws_subnet.pub_a.id # pub-subent-a에 위치
  tags = {
    Name = "test-NATgw"
  }
  depends_on = [aws_internet_gateway.igw] # igw 생성 후 만들어지도록 종속성 명시 (docs 권장사항)
}

#SUBNET
resource "aws_subnet" "pub_a" {
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.0.0/24" # VPC 내 범위 지정. 0,1 = pub / 10,11 = web / 20,21 = WAS / 30,31 = DB
  availability_zone       = "ap-northeast-2a" # 서울 리전 지정
  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "pub_c" {
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2c"
  tags = {
    Name = "public-subnet-c"
  }
}

resource "aws_subnet" "web_pri_a" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "web-subnet-a"
  }
}

resource "aws_subnet" "web_pri_c" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "web-subnet-c"
  }
}

resource "aws_subnet" "was_pri_a" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "WAS-subnet-a"
  }
}

resource "aws_subnet" "was_pri_c" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "WAS-subnet-c"
  }
}

resource "aws_subnet" "db_pri_a" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "DB-subnet-a"
  }
}

resource "aws_subnet" "db_pri_c" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.31.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "DB-subnet-c"
  }
}

#ROUTE TABLE
resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.test.id
  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.igw.id # IGW 지정
  }
  tags = {
    Name = "TEST-PUBLIC-RT"
  }
}

resource "aws_route_table" "web_pri" {
  vpc_id = aws_vpc.test.id
#   route {  #퍼블릭에 있는 NAT와 연결
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.natgw.id
#   }
  tags = {
    Name = "TEST-WEB-RT"
  }
}
resource "aws_route_table" "was_pri" {
  vpc_id = aws_vpc.test.id
  tags = {
    Name = "TEST-WAS-RT"
  }
}
resource "aws_route_table" "db_pri" {
  vpc_id = aws_vpc.test.id
  tags = {
    Name = "TEST-DB-RT"
  }
}

#라우팅 테이블을 각 서브넷에 연결
resource "aws_route_table_association" "public-a-rtb" {
  subnet_id      = aws_subnet.pub_a.id
  route_table_id = aws_route_table.pub.id
}
resource "aws_route_table_association" "public-c-rtb" {
  subnet_id      = aws_subnet.pub_c.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "web_private-a-rtb" {
  subnet_id      = aws_subnet.web_pri_a.id
  route_table_id = aws_route_table.web_pri.id
}
resource "aws_route_table_association" "web_private-c-rtb" {
  subnet_id      = aws_subnet.web_pri_c.id
  route_table_id = aws_route_table.web_pri.id
}

resource "aws_route_table_association" "was_private-a-rtb" {
  subnet_id      = aws_subnet.was_pri_a.id
  route_table_id = aws_route_table.was_pri.id
}
resource "aws_route_table_association" "was_private-c-rtb" {
  subnet_id      = aws_subnet.was_pri_c.id
  route_table_id = aws_route_table.was_pri.id
}

resource "aws_route_table_association" "db_private-a-rtb" {
  subnet_id      = aws_subnet.db_pri_a.id
  route_table_id = aws_route_table.db_pri.id
}
resource "aws_route_table_association" "db_private-c-rtb" {
  subnet_id      = aws_subnet.db_pri_c.id
  route_table_id = aws_route_table.db_pri.id
}
