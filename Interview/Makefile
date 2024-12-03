force=false
resultDir=results

entry:
	@echo "No command given.";

extract-results:
	node src/extract-results.mjs;

convert-to-wav:
	cd $(resultDir);\
	for webm in *.webm; do\
		ffmpeg -i "$$webm" "$${webm%.webm}.wav" -vn -y;\
		rm "$$webm";\
		echo "$$webm converted.";\
	done;

clean-results:
	rm $(resultDir)/* -f;

generate-csv:
	node src/generate-csv.mjs;