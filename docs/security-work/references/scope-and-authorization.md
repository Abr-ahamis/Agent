# Scope and authorization gate

Before active scanning, fuzzing, authentication testing, exploitation, or post-access work, record the authorized engagement type (CTF/lab, bounty, or formal assessment), exact targets, owner/program source, time window, rate limits, exclusions, credentials/accounts, allowed techniques, stop conditions, and evidence-handling rules.

A public IP or website is not authorization. Treat linked hosts, cloud services, CDNs, shared hosting, third-party APIs, and neighboring systems as out of scope unless expressly included. Discovery never expands scope by itself.

Start with supplied artifacts and read-only preparation. Select the least intrusive operation that answers the next question. Confirm the expected request volume and possible side effects before active tests. Stop on instability, unexpected data exposure, out-of-scope redirection, or unclear authorization. Get explicit approval for destructive changes, code execution, privilege escalation, directory modification, credential testing, relay, persistence, lateral movement, or production changes.

If scope or essential permission is ambiguous, do not perform the dependent action. Continue safe research or artifact analysis and ask for the missing boundary. Store the written scope source and decisions, not secrets.
