.PHONY: doc clean

all: doc

doc:
	appledoc --project-name 'Linear Obj-C' --project-company 'Sony' --create-html --no-create-docset --output . ../include/

clean:
	@rm -f *~;
	rm -fr html/
