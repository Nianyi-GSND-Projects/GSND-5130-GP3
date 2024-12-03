force=false
resultDir=results

entry:

reextract: fclean extract

extract:
	node src/extract-results.mjs;

clean:
ifeq ($(force), true)
	make fclean;
else
	@echo "Clean aborted. Please perform with \"force=true\".";
endif

fclean:
	rm $(resultDir)/*;