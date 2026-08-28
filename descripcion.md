#### Instalar aws cli
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash

##### Configurar el ambiente con las credenciales proporcionadas por re/start
aws configure

#### Verificar la conexión con el laboratorio
aws sts get-caller-identity

#### Crear la VPC
aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=Lab-VPC}]'
    
## Id de la VPC: vpc-088c6ac26ecb1ebb0
aws ec2 describe-vpcs --vpc-ids vpc-088c6ac26ecb1ebb0

#### Crear la subred publica
aws ec2 create-subnet \
    --vpc-id vpc-088c6ac26ecb1ebb0 \
    --cidr-block 10.0.0.0/24 \
    --availability-zone us-west-2a \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Public-subnet}]'

## Id Public-subnet: subnet-006d4f5cc03fe0243

#### Crear la subred privada
aws ec2 create-subnet \
    --vpc-id vpc-088c6ac26ecb1ebb0 \
    --cidr-block 10.0.1.0/24 \
    --availability-zone us-west-2a \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private-subnet}]'

## Id Private-subnet: subnet-08453d1f1fd76ebbd

#### Describir las tablas de enrutamiento
aws ec2 describe-route-tables \
    --filters "Name=vpc-id,Values=vpc-088c6ac26ecb1ebb0" \
    --output table

## RouteTableID: rtb-0002b043d5f745901

#### Verificando las asociaciones de rtb-0002b043d5f745901
aws ec2 describe-route-tables \
    --filters "Name=vpc-id,Values=vpc-088c6ac26ecb1ebb0" \
    --query "RouteTables[].Associations[].{RouteTable:RouteTableId, Subnet:SubnetId, Main:Main}" \
    --output table

#### Asociar esta tabla de enrutamiento con la subred pública
aws ec2 associate-route-table \
    --subnet-id subnet-006d4f5cc03fe0243 \
    --route-table-id rtb-0002b043d5f745901

#### Crear una tabla de enrutamiento privada
aws ec2 create-route-table \
    --vpc-id vpc-088c6ac26ecb1ebb0 \
    --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=Private-Route-Table}]'

#### Id de la tabla de enrutamiento privada: rtb-06aca178c20f0eeed

#### Asociar esta tabla de enrutamiento con la subred privada
aws ec2 associate-route-table \
    --subnet-id subnet-08453d1f1fd76ebbd \
    --route-table-id rtb-06aca178c20f0eeed

#### Añadiendo el nombre a la tabla de enrutamiento pública
aws ec2 create-tags \
    --resources rtb-0002b043d5f745901 \
    --tags 'Key=Name,Value=Public-Route-Table'

#### Creamos dos subredes en una segunda zona de disponibilidad
#### Crear la subred publica
aws ec2 create-subnet \
    --vpc-id vpc-088c6ac26ecb1ebb0 \
    --cidr-block 10.0.2.0/24 \
    --availability-zone us-west-2b \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Public-subnet-2}]'

## Id Public-subnet: subnet-01c6eaf32fd0bfdd2

#### Crear la subred privada
aws ec2 create-subnet \
    --vpc-id vpc-088c6ac26ecb1ebb0 \
    --cidr-block 10.0.3.0/24 \
    --availability-zone us-west-2b \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private-subnet-2}]'

## Id Private-subnet: subnet-088bcb5cad4d7f3c1

#### Las asociamos con sus respectivas tablas de enrutamiento
#### Asociar la tabla de enrutamiento publica con la subred pública
aws ec2 associate-route-table \
    --subnet-id subnet-01c6eaf32fd0bfdd2 \
    --route-table-id rtb-0002b043d5f745901

#### Asociar la tabla de enrutamiento privada con la subred privada
aws ec2 associate-route-table \
    --subnet-id subnet-088bcb5cad4d7f3c1 \
    --route-table-id rtb-06aca178c20f0eeed

#### Crear un grupo de seguridad para la VPC