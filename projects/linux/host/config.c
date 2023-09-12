/** @file
 */
#include <redconf.h>
#include <redtypes.h>
#include <redmacs.h>
#include <redvolume.h>
#include <redapimacs.h>
#include <stdio.h>
#include <stdlib.h>
#include "config.h"

static char volume_string[REDCONF_VOLUME_COUNT][32 + 1];

void load_config(const char *config_path, VOLCONF volconf[])
{
    FILE *fp = fopen(config_path, "r");
    if (fp == NULL)
        return;

    char buf[BUFSIZ];
    int index = 0;
    while (fgets(buf, sizeof(buf), fp) != NULL)
    {
        if (buf[0] == '#' || buf[0] == '\0' || buf[0] == '\n')
            continue;

        int value[7];
        int ret = sscanf(buf, "%d %d %d %d %d %d %d %32s",
                         &value[0],
                         &value[1],
                         &value[2],
                         &value[3],
                         &value[4],
                         &value[5],
                         &value[6],
                         &volume_string[index][0]);

        if (ret != 8)
        {
            fprintf(stderr, "load_conig: wrong format\n");
            continue;
        }

        if (index >= REDCONF_VOLUME_COUNT)
        {
            fprintf(stderr, "load_conig: VOLUME_COUNT overflow\n");
            exit(1);
        }

        volconf[index].ulSectorSize = value[0];
        volconf[index].ullSectorCount = value[1];
        volconf[index].ullSectorOffset = value[2];
        volconf[index].fAtomicSectorWrite = value[3];
        volconf[index].ulInodeCount = value[4];
        volconf[index].bBlockIoRetries = value[5];
        volconf[index].ulTransMask = value[6] & RED_TRANSACT_MASK;
        volconf[index].pszPathPrefix = volume_string[index];

        index++;
    }
    fclose(fp);
}

void dump_config(const VOLCONF volconf[])
{
    for (int i = 0; i < REDCONF_VOLUME_COUNT; i++)
    {
#if __x86_64__
     /* 64-bit */
        printf("%d %ld %ld %d %d %d %d %s\n",
#else
        printf("%d %lld %lld %d %d %d %d %s\n",
#endif 
               volconf[i].ulSectorSize,
               volconf[i].ullSectorCount,
               volconf[i].ullSectorOffset,
               volconf[i].fAtomicSectorWrite,
               volconf[i].ulInodeCount,
               volconf[i].bBlockIoRetries,
               volconf[i].ulTransMask,
               volconf[i].pszPathPrefix);
    }
}
