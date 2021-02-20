# crontab-aws-watchdog-
monitor crontab by aws watchdog.

Crontabがしっかり動いているか監視するために、Watchdogが欲しかったが、クリティカルな記事を探せなかったので自作した。
Cloudformationで作成したいけど、CloudWatchEventsの部分が面倒くさそう。

# 概要

## 構成図

# AWS Lambda

## 関数

## 権限

SNS publish

# CloudWatchEvents

## アラートルール作成

アラーム > アラームの作成

メトリクスの選択をするが、Lambdaを使用しないとLambdaの項目が現れない。

呼び出し選択

平均値：適当な値

Invosticationが静的で0以下を選択

欠落データの処理
欠落データを不正 (しきい値を超えている)として処理

次へ

アラーム状態を選択

SNSの通知先を選択
