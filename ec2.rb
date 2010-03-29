run "echo TODO > README"
run "curl -L http://github.com/pauldowman/ec2onrails/blob/master/examples/Capfile?raw=true  > Capfile"
run "curl -L http://github.com/phongleland/Capistrano-Deploy-File-for-RoR-and-EC2/raw/master/deploy.rb > config/deploy.rb"
run "curl -L http://github.com/pauldowman/ec2onrails/tree/master/examples/s3.yml?raw=true > config/s3.yml"

aws_access_key = ask("What is your aws acces key?")
run "perl -pi -e 's/ABC123/"+aws_access_key+"/g' config/s3.yml"
run "perl -pi -e 's/DEF456/"+aws_access_key+"/g' config/s3.yml"

aws_secret_access_key = ask("What is your aws secret access key?")
run "perl -pi -e 's/abc123abc123abc123abc123/"+aws_secret_access_key+"/g' config/s3.yml"
run "perl -pi -e 's/def456def456def456def456/"+aws_secret_access_key+"/g' config/s3.yml"

bucket_base_name = ask("What is your bucket base name?")
run "perl -pi -e 's/yourbucket/"+bucket_base_name+"/g' config/s3.yml"

location_url= ask("What is the location url of your EC2 instance?")
run "perl -pi -e 's/ec2-xxx-xxx-xxx-xxx.compute-1.amazonaws.com/"+location_url+"/g' config/deploy.rb"


database_user= ask("What is the database username?")
database_password=ask("What is the database password?")
app_name=@root.split('/').last

run "echo  'development:' > config/database.yml"
run "echo  '  adapter: sqlite3' >> config/database.yml"
run "echo  '  database: "+app_name+"_development' >> config/database.yml"
run "echo  '  pool: 5' >> config/database.yml"
run "echo  '  timeout: 5000' >> config/database.yml"

run "echo  'test:' >> config/database.yml"
run "echo  '  adapter: sqlite3' >> config/database.yml"
run "echo  '  database: "+app_name+"_test' >> config/database.yml"
run "echo  '  pool: 5' >> config/database.yml"
run "echo  '  timeout: 5000' >> config/database.yml"

run "echo  'production:' >> config/database.yml"
run "echo  '  adapter: mysql' >> config/database.yml"
run "echo  '  encoding: utf8' >> config/database.yml"
run "echo  '  reconnect: false' >> config/database.yml"
run "echo  '  database: "+app_name+"_production' >> config/database.yml"
run "echo  '  pool: 5' >> config/database.yml"
run "echo  '  username: "+database_user+"' >> config/database.yml"
run "echo  '  password: "+database_password+"' >> config/database.yml"
run "echo  '  host: db_primary' >> config/database.yml"


generate :nifty_layout


git :init

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
db/*.sqlite3
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
# 
# 
git :add => "."
git :commit => "-m 'initial commit'"

run "cap ec2onrails:server:set_roles"
run "cap ec2onrails:setup"
run "cap deploy:cold"