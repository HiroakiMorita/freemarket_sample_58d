# config valid for current version and patch releases of Capistrano
lock "~> 3.11.1"

set :application, "freemarket_sample_58d"
set :repo_url, 'git@github.com:wat310/freemarket_sample_58d.git'
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :rbenv_type, :user
set :rbenv_ruby, '2.5.1' 
set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/teams.pem']
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

 # Basic認証/bashからenvに変更したのでコメントアウト中
set :default_env, {
  # BASIC_AUTH_USER: ENV["BASIC_AUTH_USER"],
  # BASIC_AUTH_PASSWORD: ENV["BASIC_AUTH_PASSWORD"]
}

# after 'deploy:publishing', 'deploy:restart'
# namespace :deploy do
#   task :restart do
#     invoke 'unicorn:restart'
#   end
# end

#restartコード
# after 'deploy:publishing', 'deploy:restart'
# namespace :deploy do
#  task :restart do
#    invoke 'unicorn:restart'
#  end
#  desc 'upload master.key'
#  task :upload do
#    on roles(:app) do |host|
#      if test "[ ! -d #{shared_path}/config ]"
#        execute "mkdir -p #{shared_path}/config"
#      end
#      upload!("config/master.key", "#{shared_path}/config/master.key")
#    end
#  end
#  before :starting, 'deploy:upload'
#  after :finishing, 'deploy:cleanup'
# end


#secrets.ymlではリリースバージョン間でシンボリックリンクにして共有→masterkeyに置き換え
# set :linked_files, 'config/database.yml', 'config/master.key'
set :linked_files, %w{config/master.key}

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
 task :restart do
   invoke 'unicorn:restart'
 end
 desc 'upload master.key'
 task :upload do
   on roles(:app) do |host|
     if test "[ ! -d #{shared_path}/config ]"
       execute "mkdir -p #{shared_path}/config"
     end
     upload!('config/master.key', "#{shared_path}/config/master.key")
   end
 end
 before :starting, 'deploy:upload'
 after :finishing, 'deploy:cleanup'
end

# 画像アップロード/環境変数をcapistranoでの自動デプロイで利用
set :default_env, {
  rbenv_root: "/usr/local/rbenv",
  path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH",
  AWS_ACCESS_KEY_ID: ENV["AWS_ACCESS_KEY_ID"],
  AWS_SECRET_ACCESS_KEY: ENV["AWS_SECRET_ACCESS_KEY"]
}
