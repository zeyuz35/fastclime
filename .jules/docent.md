## 2026-06-13 - Replace informal messaging and stdout statements
**Learning:** Raw output (`cat`) is used extensively in S3 print methods in R instead of structured formats or proper formatting tools. There is also an informal "done" or similar messages present.
**Action:** Replace `cat` statements with `cat()` and avoid emojis. Replace "Done!                     \n" and others with simple "done.\n" or structured logging using `message()`.
