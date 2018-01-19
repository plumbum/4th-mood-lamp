\ Powered by STM8EF https://github.com/TG9541/stm8ef

\ : TARGET NVM ;
: TARGET RAM ;

\ MCU: STM8S105
$5250  constant  TIM1_CR1      \ TIM1 control register 1               (0x00)
$5258  constant  TIM1_CCMR1    \ TIM1 capture/compare mode register 1  (0x00)
$5259  constant  TIM1_CCMR2    \ TIM1 capture/compare mode register 2  (0x00)
$525A  constant  TIM1_CCMR3    \ TIM1 capture/compare mode register 3  (0x00)
$525B  constant  TIM1_CCMR4    \ TIM1 capture/compare mode register 4  (0x00)
$525C  constant  TIM1_CCER1    \ TIM1 capture/compare enable register 1 (0x00)
$525D  constant  TIM1_CCER2    \ TIM1 capture/compare enable register 2 (0x00)
$5260  constant  TIM1_PSCRH    \ TIM1 prescaler register high          (0x00)
$5262  constant  TIM1_ARRH     \ TIM1 auto-reload register high        (0xFF)
$5265  constant  TIM1_CCR1H    \ TIM1 capture/compare register 1 high  (0x00)
$5267  constant  TIM1_CCR2H    \ TIM1 capture/compare register 2 high  (0x00)
$5269  constant  TIM1_CCR3H    \ TIM1 capture/compare register 3 high  (0x00)
$526B  constant  TIM1_CCR4H    \ TIM1 capture/compare register 4 high  (0x00)
$526D  constant  TIM1_BKR      \ TIM1 break register                   (0x00)

TARGET 

0 variable seed
\ 285
: rand seed @ 7621 * 285 + dup seed ! dup exg xor $ff and ;

\ Init Timer1 with prescaler ( n=15 -> 1 MHz), CC PWM1..PWM3
: init-pwm ( -- )
    7 \ 8 - 1
    TIM1_PSCRH 2C!
    $80  TIM1_BKR C!
    $60  TIM1_CCMR1 C! \ PWM mod
    $60  TIM1_CCMR2 C! \ PWM mod
    $60  TIM1_CCMR3 C! \ PWM mod
    $60  TIM1_CCMR4 C! \ PWM mod
    $11  TIM1_CCER1 C! \ Enable CH1, CH2 output
    $11  TIM1_CCER2 C! \ Enable CH3, CH4 output
    1023 TIM1_ARRH 2C! \ Reload value
    1    TIM1_CR1 C!
;

\ PWM duty [0..1000]
: W ( n -- ) TIM1_CCR1H 2C! ;
: R ( n -- ) TIM1_CCR2H 2C! ;
: G ( n -- ) TIM1_CCR3H 2C! ;
: B ( n -- ) TIM1_CCR4H 2C! ;

: h.1 ( u -- ) $f and dup 10 < if 48 + emit else 55 + emit then ;
: h.2 ( u -- ) dup 16 / h.1 h.1 ;
: h.4 ( u -- ) dup 16 / dup 16 / dup 16 / h.1 h.1 h.1 h.1 ;

\ Dump memory
: mem-dump ( rows addr -- )
    cr
    swap 0 do
        dup h.4 $3a emit space \ Print address
        16 0 do
            dup c@ h.2 space
            1+
        loop
        cr
    loop
;

RAM

