```
    cmul  = (a + jb)(c + jd) = (ac - bd) + j(bc + ad)
    conj  = (a + jb)(c - jd) = (ac + bd) + j(bc - ad)
    magsq =                    (aa + bb) + j(cc + dd)
    add   =                    (a1 + 1c) + j(1b + 1d)
    sub   =                    (a1 - 1c) + j(1b - 1d)

                            cmul / conj             magsq         add / sub
    a               a
    a, c, 1, 1      c *               01                00                10
    b, c, 1, 1      b               00                00                01
    b, d, 1, 1      d *           01                00                10
                    -     01                00                00
    c, b, 1, 1      b           01                00                01
    c, d, 1, 1      c *       00                00                10
    d, a, 1, 1      a       01                00                10
    d
                    +   00                00                00

                        0001010001010001  0000000000000000  0000101001100110
                                    1451              0000              0a66

                        0100010001010001                    0101101001100110
                                    4451                                5a66
```
