main:
	pandoc -c pandoc.css -s -o proverbs.html proverbs.md
	pandoc -c pandoc.css -s -o index.html harrison_brewton.md

push:
	git add *
	echo git commit -m 'pushed on $(date)'
	git push
