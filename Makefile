main:
	pandoc -c pandoc.css -s -o proverbs.html proverbs.md
	pandoc -c pandoc.css -s -o index.html harrison_brewton.md

push:
	git add *
	git commit -m "view updated main page"
	git push
