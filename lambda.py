import boto3

def create_cloudwatch_alarm(instance_id):
    client = boto3.client('cloudwatch')
    
    alarm_name = 'HighCPUAlarm'
    alarm_description = 'Triggered when CPU usage exceeds 80% for 5 minutes'
    metric_name = 'CPUUtilization'
    namespace = 'AWS/EC2'
    statistic = 'Average'
    comparison_operator = 'GreaterThanThreshold'
    threshold = 80
    evaluation_periods = 5
    period = 60
    alarm_actions = ['arn:aws:sns:us-east-1:123456789012:MyTopic']
    
    client.put_metric_alarm(
        AlarmName=alarm_name,
        AlarmDescription=alarm_description,
        ActionsEnabled=True,
        AlarmActions=alarm_actions,
        MetricName=metric_name,
        Namespace=namespace,
        Statistic=statistic,
        ComparisonOperator=comparison
