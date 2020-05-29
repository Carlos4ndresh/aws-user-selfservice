resource "aws_cloudformation_stack" "instance_scheduler_stack" {
  name = "instance-scheduler-stack"
  capabilities = ["CAPABILITY_IAM"]

  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }

  parameters = {
    SchedulingActive = "Yes",
    ScheduledServices = "Both",
    ScheduleRdsClusters = "No",
    CreateRdsSnapshot = "No",
    MemorySize = "384",
    UseCloudWatchMetrics = "Yes",
    LogRetentionDays = "30",
    Trace = "No",
    TagName = "InstanceSchedule",
    DefaultTimezone = "America/Bogota",
    Regions = "us-east-1,us-east-2,us-west-1,us-west-2",
    CrossAccountRoles = "",
    StartedTags = "ScheduleStartMessage=Started on {year}/{month}/{day} at {hour}:{minute} {timezone} y scheduler {scheduler}",
    StoppedTags = "ScheduleStopMessage=Started on {year}/{month}/{day} at {hour}:{minute} {timezone} y scheduler {scheduler}",
    SchedulerFrequency = "5",
    ScheduleLambdaAccount = "Yes",
    SendAnonymousData = "Yes",
  }

  template_url = "https://s3.amazonaws.com/solutions-reference/aws-instance-scheduler/latest/instance-scheduler.template"
}

resource "aws_cloudformation_stack" "SchedulerCustomResource" {
  name = "instance-scheduler-stack-custom-resource"
  capabilities = ["CAPABILITY_IAM"]

  tags = {
    owner = var.owner,
    project = var.project,
    provisioner = var.provisioner,
    env = var.env
  }

  template_body = <<STACK
AWSTemplateFormatVersion: 2010-09-09
Metadata:
  'AWS::CloudFormation::Designer': {}
Resources:
  MedellinOfficeHours:
    Type: 'Custom::ServiceInstanceSchedule'
    Properties:
      Name: MED-OfficeHours
      NoStackPrefix: 'True'
      Description: Office hours in Medellin
      ServiceToken: >-
        ${aws_cloudformation_stack.instance_scheduler_stack.outputs["ServiceInstanceScheduleServiceToken"]}
      Enforced: 'True'
      Timezone: America/Bogota
      Periods:
        - Description: Opening hours on weekdays
          BeginTime: '08:00'
          EndTime: '18:00'
          WeekDays: Mon-Fri
STACK
}