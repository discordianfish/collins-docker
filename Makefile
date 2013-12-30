APP_SECRET=$(shell tr -cd '[:alnum:]' < /dev/urandom | fold -w64 | head -n1)
CRYPTO_KEY=$(shell tr -cd '[:alnum:]' < /dev/urandom | fold -w64 | head -n1)

all: conf/production.conf
	docker build -t collins .

conf/production.conf: conf/production.conf.tmpl
	sed 's/<APP_SECRET>/$(APP_SECRET)/g;s/<CRYPTO_KEY>/$(CRYPTO_KEY)/g' $< > $@

clean:
	rm conf/*.tmpl
