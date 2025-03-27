edit-api-to-test:
	sed -i '' 's|https://api.mymfbox.com|https://testapi.mymfbox.com|g' lib/api/ApiConfig.dart

edit-api-to-og:
	sed -i '' 's|https://testapi.mymfbox.com|https://api.mymfbox.com|g' lib/api/ApiConfig.dart

add-and-commit:
	make edit-api-to-og
	git add .
	git commit || true
	make edit-api-to-test

add-and-commit-amend:
	make edit-api-to-og
	git add .
	git commit --amend || true
	make edit-api-to-test

switch-main:
	make edit-api-to-og
	git switch main

checkout:
	make edit-api-to-og
	git checkout -b $(b)
	make edit-api-to-test

switch--b:
	make edit-api-to-og
	git checkout -b $(b)
	make edit-api-to-test
