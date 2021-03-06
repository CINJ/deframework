/* autogenerated by make_exe.pl, do not edit */
#ifndef DECRUNCHERS_H
#define DECRUNCHERS_H

#include <stdint.h>

enum fixtype_t {
    ftBufZp = 1,
    ftDecruncher,
    ftDestEnd,
    ftEndMarkerMinusOne,
    ftSrcEnd,
    ftEnd = -1
};

typedef struct {
    enum fixtype_t type;
    uint16_t addr;
} FixEntry;

#define FLAG_DIRTY (1<<0)
#define FLAG_NOCLI (1<<1)
#define FLAG_MASK (FLAG_DIRTY | FLAG_NOCLI)

#define FLAG_XBASE (1<<2)

typedef struct {
    uint16_t addr;
    uint8_t *data;
    int len;
    FixEntry *fix_entry;
    int flags;
} FixStruct;


#endif /* DECRUNCHERS_H */
/* eof */
