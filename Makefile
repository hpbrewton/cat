main:
	pandoc -c pandoc.css -s -o index.html harrison_brewton.md
	git add *
	git commit -m "view updated main page"
	git push
