static int dosearch(
	LDAP	*ld,
	char	*base,
	int		scope,
	char	*filtpatt,
	char	*value,
	char	**attrs,
	int		attrsonly,
	LDAPControl **sctrls,
	LDAPControl **cctrls,
	struct timeval *timeout,
	int sizelimit )
{
	char		filter[ BUFSIZ ];
	int			rc;
	int			nresponses;
	int			nentries;
	int			nreferences;
	int			nextended;
	int			npartial;
	LDAPMessage		*res, *msg;
	ber_int_t	msgid;

	if( filtpatt != NULL ) {
		sprintf( filter, filtpatt, value );

		if ( verbose ) {
			fprintf( stderr, "filter: %s\n", filter );
		}

		if( ldif < 2 ) {
			printf( "#\n# filter: %s\n#\n", filter );
		}

	} else {
		sprintf( filter, "%s", value );
	}

	if ( not ) {
		return LDAP_SUCCESS;
	}

	rc = ldap_search_ext( ld, base, scope, filter, attrs, attrsonly,
		sctrls, cctrls, timeout, sizelimit, &msgid );

	if( rc != LDAP_SUCCESS ) {
		fprintf( stderr, "%s: ldap_search_ext: %s (%d)\n",
			prog, ldap_err2string( rc ), rc );
		return( rc );
	}

	nresponses = nentries = nreferences = nextended = npartial = 0;

	res = NULL;

	while ((rc = ldap_result( ld, LDAP_RES_ANY,
		sortattr ? LDAP_MSG_ALL : LDAP_MSG_ONE,
		NULL, &res )) > 0 )
	{
		if( sortattr ) {
			(void) ldap_sort_entries( ld, &res,
				( *sortattr == '\0' ) ? NULL : sortattr, strcasecmp );
		}

		for ( msg = ldap_first_message( ld, res );
			msg != NULL;
			msg = ldap_next_message( ld, msg ) )
		{
			if( nresponses++ ) putchar('\n');

			switch( ldap_msgtype( msg ) ) {
			case LDAP_RES_SEARCH_ENTRY:
				nentries++;
				print_entry( ld, msg, attrsonly );
				break;

			case LDAP_RES_SEARCH_REFERENCE:
				nreferences++;
				print_reference( ld, msg );
				break;

			case LDAP_RES_EXTENDED:
				nextended++;
				print_extended( ld, msg );

				if( ldap_msgid( msg ) == 0 ) {
					/* unsolicited extended operation */
					goto done;
				}
				break;

			case LDAP_RES_EXTENDED_PARTIAL:
				npartial++;
				print_partial( ld, msg );
				break;

			case LDAP_RES_SEARCH_RESULT:
				rc = print_result( ld, msg, 1 );
				goto done;
			}
		}

		ldap_msgfree( res );
	}

	if ( rc == -1 ) {
		ldap_perror( ld, "ldap_result" );
		return( rc );
	}

done:
	if ( ldif < 2 ) {
		printf( "\n# numResponses: %d\n", nresponses );
		if( nentries ) printf( "# numEntries: %d\n", nentries );
		if( nextended ) printf( "# numExtended: %d\n", nextended );
		if( npartial ) printf( "# numPartial: %d\n", npartial );
		if( nreferences ) printf( "# numReferences: %d\n", nreferences );
	}

	return( rc );
}

