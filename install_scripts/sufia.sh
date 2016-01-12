############
# Sufia 6.5
############

echo "Installing Sufia."

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

sudo apt-get -y install libssl-dev zlib1g-dev libreadline-dev nodejs sqlite3 libsqlite3-dev redis-server

echo -n "Installing Ruby"
if [ ! -f "$DOWNLOAD_DIR/ruby-2.2.4.tar.gz" ]; then
  echo -n "Downloading Ruby 2.2.4..."
  wget -q -O "$DOWNLOAD_DIR/ruby-2.2.4.tar.gz" "https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.4.tar.gz"
  echo " done"
fi

cd /tmp
cp "$DOWNLOAD_DIR/ruby-2.2.4.tar.gz" /tmp
tar -xzf ruby-2.2.4.tar.gz
cd ruby-2.2.4
./configure
sudo make -s
sudo make -s install

echo -n "Installing Rails 4.2"
sudo gem install bundle
sudo gem install rails -v 4.2

echo -n "Installing Fits"
if [ ! -f "$DOWNLOAD_DIR/fits-0.6.2.zip" ]; then
  echo -n "Downloading Fits 0.6.2..."
  wget -q -O "$DOWNLOAD_DIR/fits-0.6.2.zip" "http://projects.iq.harvard.edu/files/fits/files/fits-0.6.2.zip?m=1385738454"
  echo " done"
fi

if [ ! -d "/opt/fits-0.6.2" ]; then
	cd /tmp
	cp "$DOWNLOAD_DIR/fits-0.6.2.zip" /tmp
	sudo unzip fits-0.6.2.zip
	sudo mv fits-0.6.2 "/opt"
	sudo chmod a+x "/opt/fits-0.6.2/fits.sh"
	if [ ! -L "/opt/fits" ]; then
		sudo ln -s "/opt/fits-0.6.2" "/opt/fits"
	fi
fi

echo -n "Installing Rails app for Sufia"
cd $HOME_DIR
rails new sufia_app
cd "sufia_app"
cp -f "$SHARED_DIR/config/Gemfile" "$HOME_DIR/sufia_app/"

bundle install
rails generate sufia:install -f

cp -f "$SHARED_DIR/config/sufia.rb" "$HOME_DIR/sufia_app/config/initializers/"
cp -f "$SHARED_DIR/config/fedora.yml" "$HOME_DIR/sufia_app/config/"
cp -f "$SHARED_DIR/config/solr.yml" "$HOME_DIR/sufia_app/config/"
cp -f "$SHARED_DIR/config/blacklight.yml" "$HOME_DIR/sufia_app/config/"

rails generate roles
rake db:migrate

echo -n "Installing Solr configuration files"
sudo cp -f "$HOME_DIR/sufia_app/solr_conf/conf/schema.xml" "$SOLR_HOME/collection1/conf"
sudo cp -f "$HOME_DIR/sufia_app/solr_conf/conf/solrconfig.xml" "$SOLR_HOME/collection1/conf"
sudo service tomcat7 restart