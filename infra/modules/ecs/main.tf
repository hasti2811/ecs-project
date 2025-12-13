resource "aws_ecs_cluster" "my-cluster" {
  name = "ecs-cluster"
}

resource "aws_ecs_task_definition" "my-cluster-td" {
  family = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
  execution_role_arn  = aws_iam_role.ecs_role.arn
  container_definitions = jsonencode([
    {
      name      = "threatmod"
      image     = var.img_uri
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000,
          protocol = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs-service" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.my-cluster.id
  task_definition = aws_ecs_task_definition.my-cluster-td.arn
  desired_count   = 2
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = var.alb_tg_arn
    container_name   = "threatmod"
    container_port   = 3000
  }

  network_configuration {
    subnets = var.subnets
    assign_public_ip = false
    security_groups = [var.ecs_sg_id]
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
}

# IAM
resource "aws_iam_role" "ecs_role" {
  name = "ecs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
