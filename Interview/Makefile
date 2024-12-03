force=false
resultDir=results

entry: extract convert

extract:
	node src/extract-results.mjs;

convert:
	cd $(resultDir);\
	for webm in *.webm; do\
		ffmpeg -i "$$webm" "$${webm%.webm}.wav" -vn -y;\
		rm "$$webm";\
		echo "$$webm converted.";\
	done;

clean:
ifeq ($(force), true)
	make fclean;
else
	@echo "Clean aborted. Please perform with \"force=true\".";
endif

fclean:
	rm $(resultDir)/* -f;