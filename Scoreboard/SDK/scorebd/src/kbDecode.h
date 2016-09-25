/*
 * kbDecode.h
 *
 *  Created on: Mar 3, 2016
 *  Author: Qinghui Liu
 */

#ifndef KBDECODE_H_
#define KBDECODE_H_

#include <stdio.h>
#include "xio.h"
//#include "xil_io.h"

//char* int2str(int i, char b[]);
//int str2Int(char str[]);
int str2Int(u8 str[]);
void int2str(int i, u8 b[]);
void int2str3(int i, u8 b[]);
u8 KbDeCode(u8 KbCode);

#endif /* KBDECODE_H_ */
