# RestfulApi

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

# 使用docker启动
  sudo docker-compose up -d web
  sudo docker-compose run web mix deps.get
  sudo docker-compose run web mix ecto.create
  sudo docker-compose run web mix ecto.migrate
  sudo docker-compose restart web
  sudo docker-compose run web

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## 计划更新内容

  * 实现Poison.encoder正确处理notloaded的值 2018-04-11
  * 自定义plug验证失败时返回相应的json结果 2018-04-11
  * 加入文本翻译功能 2018-04-12
  * 使用docker容器化应用 2018-04-12
  * 修改fallback_controller能够正确处理各类异常
  * 完善search_term中的API
  * 处理数据库连接异常