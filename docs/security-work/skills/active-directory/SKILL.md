---
{"name":"active-directory","description":"Map and assess an authorized Windows Active Directory environment using least-privilege directory, DNS, Kerberos, SMB, policy, and relationship analysis.","domain":"Active Directory","subdomains":["LDAP","Kerberos","SMB","ACLs","trusts","AD CS","BloodHound"],"triggers":["Active Directory assessment","AD domain","domain controller","LDAP enumeration","Kerberos assessment","BloodHound","SPN","Kerberoasting","AS-REP roasting","domain trust"],"excludes":["credential attack without authorization","unauthorized domain"],"prerequisites":["Confirm domain/host scope, identity, allowed collection, test window, rate, approved tools, and whether authentication/ticket operations are permitted."],"tools":["BloodHound CE","SharpHound","NetExec","Impacket","ldapsearch","PowerView","Certipy","Kerberos utilities","Windows built-ins"],"references":["../../references/scope-and-authorization.md","../../references/active-directory-enumeration.md","../../references/windows-enumeration.md","../../references/security-reporting.md"]}
---
# Active Directory assessment

## Methodology
1. Establish domain naming context, DC evidence, DNS records, current identity and query permissions. Keep local host facts distinct from domain facts.
2. Prefer bounded read-only LDAP/LDAPS and DNS queries for users, groups, computers, OUs, policies, SPNs, trusts, and security-relevant attributes. SMB checks identify dialect/signing/auth and share metadata; listing does not authorize file reads.
3. Analyze group membership, ACLs, delegation, GPO links/permissions, service account metadata, AD CS templates/CA configuration, trusts, and authentication policy. Record object, principal, right/edge, prerequisite, and resulting capability.
4. Use BloodHound/SharpHound only with collection approval and bounded scope; graph edges reflect collected, potentially stale/incomplete data. Validate candidate relationships at source.
5. Assess password policy and Kerberos exposure through configuration and metadata first. Ticket requests, credential attacks, relay, remote execution, and object modification need explicit action-specific approval.

## Decision
- DNS/DC discovery unclear: verify resolver and naming context with owner-provided domain details; do not enumerate guessed external domains.
- LDAP denied/partial: record bind identity/base DN and limitations; use authorized Windows-native queries or ask for approved read identity. Denial is not absence.
- SPNs/delegation/trust found: inspect exact account/object flags and rights; do not infer exploitable path without prerequisites.
- BloodHound path candidate: verify collection freshness, edge semantics, object ACLs and practical constraints. Route local privilege checks to Windows assessment.
- AD CS present: inventory templates/CA enrollment and issuance controls; use authorized review tools. Certificate requests or authentication with issued certs require specific permission.
- No findings: state query coverage and ACL visibility limits; ask for additional authorized query context rather than broadening collection.

## Verification
Corroborate each finding with directory attributes, effective rights, policy, and a second source when feasible. Roasting or relay result is not itself proof of domain compromise; never claim access not demonstrated.

## Safety
No password spraying/cracking, ticket abuse, relay, secrets dumping, persistence, lateral movement, or remote execution unless explicitly in scope and approved. Stop on unexpected sensitive data or production impact.

## Evidence
Record scope, query identity, DC/base DN, attributes, tool/version/collection options, graph timestamp, redacted object identifiers, ACL/edge rationale, limitations, and remediation.
