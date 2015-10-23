themes_dir=`pwd`

echo "What repository would you like to get those themes from? wp.com (c)/wp.org (o) ? [Default:wp.org]"
read REPO

if [[ -z "$REPO" ]]
then
	REPO='o'
fi

if [ $REPO == 'c' ]
then
	REPO='c'
	repo_url='https://wpcom-themes.svn.automattic.com/'
else
	REPO='o'
	repo_url='http://themes.svn.wordpress.org/'
fi

echo "Insert the themes slugs (one per line) and press ctrl+D"
MSG=$(cat)

echo "Fetching themes from $repo_url. This could take some time"

for theme in $MSG
do
	svn co -q $repo_url$theme'/' $theme

	if [ $REPO == 'o' ]
	then
		last_version=`ls -v $theme | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail -1`
		for x in `ls $theme`
		do
			if [ $last_version != $x ]
			then
				rm -r $themes_dir"/"$theme"/"$x
			fi
		done

		mv $theme"/"$last_version/*  $theme"/"
		rm -r $theme"/"$last_version
	fi

	rm -r $theme"/.svn"
done



exit 1
