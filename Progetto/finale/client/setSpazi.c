#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

static void reportDipendenti(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;


    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call ReportDipendentiTrasferire()", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize 'ReportDipendentiTrasferire' statement\n", false);
    }

    // No parameters to prepare
    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while retrieving employees' report.");
        goto out;
    }

    do {
        dump_result_set(conn, prepared_stmt, "\nDipendenti trovati:");
    } while (mysql_stmt_next_result(prepared_stmt) == 0); //mi assicuro di consumare tutto il result set, altrimenti potrei ottenere "out of sync"

    out:
    mysql_stmt_close(prepared_stmt);
}


static void reportDipendentiMansione(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;


    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call DipendentiTrasferireMansione()", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize dipendentiTrasferireMansione statement\n", false);
    }

    // No parameters to prepare
    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while retrieving employees' report grouped by job.");
        goto out;
    }

    do {
        dump_result_set(conn, prepared_stmt, "\nDipendenti trovati:");
    } while (mysql_stmt_next_result(prepared_stmt) == 0);//mi assicuro di consumare tutto il result set, altrimenti potrei ottenere "out of sync"

    out:
    mysql_stmt_close(prepared_stmt);
}

static void trasferisciDipendente(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[2];

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call Trasferimento(?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize 'Trasferimento' statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("Inserisci il codice fiscale del dipendente da trasferire: ");
    char string[16];
    getInput(16, string, false);
    param[0].buffer = string;
    param[0].buffer_length = strlen((char *)param[0].buffer);

    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("\nInserisci il numero ESTERNO della postazione in cui trasferire il dipendente\n");
    printf("[N.B: La postazione deve essere libera e compatibile con la mansione del dipendente scelto]\n");
    char postazione[45];
    getInput(45, postazione, false);
    param[1].buffer = postazione;
    param[1].buffer_length = strlen((char *)param[1].buffer);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for transfer\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while transfering the employee.");
        goto out;
    }

    //La call non produce un output in questo caso
    printf("Trasferimento eseguito con successo");

    out:
    mysql_stmt_close(prepared_stmt);
}

static void scambioDipendenti(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[2];

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call ScambioPostazione(?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize 'ScambioPostazione' statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("Inserisci il codice fiscale del primo dipendente da scambiare: ");
    char string[16];
    getInput(16, string, false);
    param[0].buffer = string;
    param[0].buffer_length = strlen((char *)param[0].buffer);

    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("\nInserisci il codice fiscale del primo dipendente da scambiare: ");
    char string2[16];
    getInput(16, string2, false);
    param[1].buffer = string2;
    param[1].buffer_length = strlen((char *)param[1].buffer);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for post switch\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while switching posts.");
        goto out;
    }

    //La call non produce un output in questo caso
    printf("Scambio di postazioni eseguito con successo");

    out:
    mysql_stmt_close(prepared_stmt);
}

static void inserisciDipendente(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[12];
    MYSQL_TIME ts, ts2;

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call InserisciDipendente(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize 'InserisciDipendente' statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    //codice fiscale
    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("Inserisci il codice fiscale del dipendente da trasferire: ");
    char string[16];
    getInput(16, string, false);
    param[0].buffer = string;
    param[0].buffer_length = strlen((char *)param[0].buffer);

    //numero postazione
    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("\nInserisci il numero ESTERNO della postazione in cui inserire il dipendente\n");
    printf("[N.B: La postazione deve essere libera e compatibile con la mansione del dipendente scelto]\n");
    char postazione[45];
    getInput(45, postazione, false);
    param[1].buffer = postazione;
    param[1].buffer_length = strlen((char *)param[1].buffer);

    //data trasferimento/assunzione
    param[2].buffer_type = MYSQL_TYPE_DATE;
    char *today;
    size_t s = 0;
    printf("\nInserisci la data di assunzione del dipendente nel formato YYYY-MM-DD: ");
    getline(&today, &s, stdin);
    date_to_mysql_time(today, &ts);
    param[2].buffer = &ts;
    param[2].buffer_length = sizeof(ts);


   //mansione
    param[3].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("\nInserisci la mansione del nuovo dipendente: ");
    char mansione[45];
    getInput(45, mansione, false);
    param[3].buffer = mansione;
    param[3].buffer_length = strlen((char *)param[3].buffer);

    //nome
    param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("\nInserisci il nome del nuovo dipendente: ");
    char nome[45];
    getInput(45, nome, false);
    param[4].buffer = nome;
    param[4].buffer_length = strlen((char *)param[4].buffer);

    //cognome
    param[5].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("\nInserisci il cognome del nuovo dipendente: ");
    char cognome[45];
    getInput(45, cognome, false);
    param[5].buffer = cognome;
    param[5].buffer_length = strlen((char *)param[5].buffer);

    //data di nascita
    param[6].buffer_type = MYSQL_TYPE_DATE;
    char *buffer;
    size_t sz = 0;
    printf("\nInserisci la data di nascita del dipendente nel formato YYYY-MM-DD: ");
    getline(&buffer, &sz, stdin);
    date_to_mysql_time(buffer, &ts2);
    param[6].buffer = &ts2;
    param[6].buffer_length = sizeof(ts2);

    //Luogo di nascita
    param[7].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("\nInserisci il paese di nascita del nuovo dipendente: ");
    char luogoNascita[45];
    getInput(45, luogoNascita, false);
    param[7].buffer = luogoNascita;
    param[7].buffer_length = strlen((char *)param[7].buffer);

    //Città residenza
    param[8].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("\nInserisci la città di residenza del nuovo dipendente: ");
    char citta[45];
    getInput(45, citta, false);
    param[8].buffer = citta;
    param[8].buffer_length = strlen((char *)param[8].buffer);

    //Via residenza
    param[9].buffer_type = MYSQL_TYPE_VAR_STRING;
    char via[45];
    printf("\nInserisci la via di residenza del nuovo dipendente: ");
    getInput(45, via, false);
    param[9].buffer = via;
    param[9].buffer_length = strlen((char *)param[9].buffer);

    //civico indirizzo
    param[10].buffer_type = MYSQL_TYPE_LONG; //int in sql
    printf("\nInserisci il numero civico di residenza del nuovo dipendente: ");
    getline(&buffer, &sz, stdin);
    int civico;
    sscanf(buffer, "%d", &civico);
    param[10].buffer = (void *)&civico;
    param[10].buffer_length = strlen((char *)param[10].buffer);

    //email personale (quella aziendale è generata dal DBMS
    param[11].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("\nInserisci l'email personale del nuovo dipendente: ");
    char emailPers[45];
    getInput(45, emailPers, false);
    param[11].buffer = emailPers;
    param[11].buffer_length = strlen((char *)param[11].buffer);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for 'InserisciDipendente'\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while inserting the new employee.");
        goto out;
    }

    //La call non produce un output in questo caso
    printf("Inserimento dipendente eseguito con successo");

    out:
    mysql_stmt_close(prepared_stmt);
}

static void eliminaDipendente(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[1];

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call EliminaDipendente(?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize 'EliminaDipendente' statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("Inserisci il codice fiscale del dipendente da eliminare: ");
    char string[16];
    getInput(16, string, false);
    param[0].buffer = string;
    param[0].buffer_length = strlen((char *)param[0].buffer);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for 'EliminaDipendente'\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while removing the selected employee, no changes were made to Directory Aziendale.");
        goto out;
    }


    //non produce result set
    printf("Dipendente rimosso con successo dalla directory aziendale");

    out:
    mysql_stmt_close(prepared_stmt);
}


void runAsSetSpazi(MYSQL *conn)
{
	char options[11] = { '0','1','2', '3', '4', '5', '6', '7', '8', '9', 'X'};
	char op;
	
	printf("Passaggio a account Settore Spazi\n");

	if(!parse_config("users/setSpazi.json", &conf)) {
		fprintf(stderr, "Unable to load professor configuration\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

	while(true) {
		printf("\033[2J\033[H");
        printf("*** Quale Operazione vuoi eseguire? ***\n\n");
        printf("0) Ricerca dipendente per nome\n");
        printf("1) Ricerca dipendente per cognome\n");
        printf("2) Ricerca dipendente per nome e cognome\n");
        printf("3) Ricerca postazione\n");
        printf("4) Report Dipendenti da Trasferire\n");
        printf("5) Report Dipendenti da Trasferire (raggruppati per Mansione)\n");
        printf("6) Trasferimento Dipendente\n");
        printf("7) Scambio postazione tra dipendenti\n");
        printf("8) Inserisci dipendente\n");
        printf("9) Elimina dipendente\n");
        printf("X) Esci\n");





        op = multiChoice("Seleziona un'opzione", options, 11);

		switch(op) {
			case '0':
                ricercaDipNome(conn);
				break;
				
			case '1':
                ricercaDipCognome(conn);
                break;
            case '2':
                ricercaDipNomeCognome(conn);
                break;
            case '3':
                ricercaPostazione(conn);
                break;
            case '4':
                reportDipendenti(conn);
                break;
            case '5':
                reportDipendentiMansione(conn);
                break;
            case '6':
                trasferisciDipendente(conn);
                break;
            case '7':
                scambioDipendenti(conn);
                break;
            case '8':
                inserisciDipendente(conn);
                break;
            case '9':
                eliminaDipendente(conn);
                break;
            case 'X':
                return;
				
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		getchar();
	}
}
