# Active Directory enumeration

Treat AD as a directory and trust environment, not just a Windows host. Establish domain, naming context, domain-controller evidence, current identity/auth context, approved query methods, and collection limits before querying. Keep local-machine facts separate from domain facts.

## Read-only mapping

Within scope, map domains/trusts, DCs and relevant DNS records, users/groups/computers/OUs, group membership, delegated ACLs, policy facts, service-account metadata/SPNs, LDAP/LDAPS reachability, SMB shares/permissions, remote-management paths, and AD CS presence/config. Use least-privilege LDAP or Windows-native queries first. Record query identity, base DN, attributes, server, and access limitations. Do not collect broad credential material.

Impacket, NetExec, ldapsearch, PowerView, Certipy, Kerbrute, SharpHound, and BloodHound have distinct query and operational effects; consult their catalog entries and exact local version. Collection may be high volume. BloodHound graphs represent collected relationships; verify edge permissions and freshness before describing a path.

## Relationship and attack-path reasoning

For each candidate, name the object, principal, ACL/right, group or delegation edge, configuration prerequisite, and resulting capability. Check excessive privileges, service-account settings, important-object permissions, certificate template/CA policy, and trust boundaries from actual evidence. A path hypothesis or scanner finding is not compromise.

Separate read-only discovery from actions that authenticate as another identity, request/use tickets, relay authentication, modify directory objects, exploit services, or execute remotely. Each such action needs explicit authorization. Never run broad collection or credential operations merely because a tool supports them. Report incomplete ACL visibility and recommend owner-side verification where necessary.
