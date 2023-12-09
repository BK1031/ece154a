
ifndef TEST_CACHE
$(error You did not define TEST_CACHE!)
endif

cache-test: cache-test-skel.c $(TEST_CACHE)
	gcc -Wall $^ -o $@
