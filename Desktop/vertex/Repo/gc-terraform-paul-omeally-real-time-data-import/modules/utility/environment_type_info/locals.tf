locals {
  environment_type_info_map = {
        sandbox = {
          accountId = "912926176250"
          role_arn = "arn:aws:iam::474562475633:role/Admin"
          vpc_id = data.aws_vpc.vpc.id
        }
        dev = {
          accountId = "517433648023"
          role_arn = "arn:aws:iam::517433648023:role/VATAdmin"
          vpc_id = data.aws_vpc.vpc.id
        }
        test = {
          accountId = "474562475633"
          role_arn = "arn:aws:iam::474562475633:role/Admin"
          vpc_id = data.aws_vpc.vpc.id
        }
  }
}