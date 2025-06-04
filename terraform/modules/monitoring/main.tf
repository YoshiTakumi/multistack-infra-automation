resource "aws_sns_topic" "high_memory_alert" {
    name = "high-memory-alert"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.high_memory_alert.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "vote_app_high_mem" {
  alarm_name          = "vote-app-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_actions       = [aws_sns_topic.high_memory_alert.arn]
  dimensions = {
    InstanceId = module.compute.vote_app_instance_id
  }
}