;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Space invaders
{require 2htdp/image}
{require 2htdp/universe}

;; =========
;; Constants

(define WIDTH 300)  ; WIDTH of the game area
(define HEIGHT 500) ; HEIGHT of the game area
(define MTS (empty-scene WIDTH HEIGHT 'black)) ; Background for the game

(define TANK (above (rectangle 2 10 'solid 'white)
                    (rectangle 20 10 'solid 'white)))    ; Image of a laser tank
(define SHOT (ellipse 3 30 'solid 'yellow))	 ; Image of a laser shot
(define INVADER (overlay/align 'center
                               'bottom
                               (ellipse 10 20 'outline 'green)
                               (ellipse 30 10 'solid 'green)))   ; Image of an invader

(define SPEED-TANK 3)  ; Speed of a tank
(define SPEED-SHOT 10)    ; Speed of a shot

(define SPEED-INVADER-X 2) ; Speed of an invader (x-axis)
(define SPEED-INVADER-Y 1) ; Speed of an invader (y-axis)
(define CREATE-INVADERS-RATE-0 50) ; Create rate for invaders when ListOfInvaders is empty
(define CREATE-INVADERS-RATE-1 1) ; Create rate for invaders when ListOfInvaders is not empty


;; ================
;; Data definitions

(define-struct game (tank shots invaders))
;; Game is (make-game Tank ListOfShots ListOfInvaders)
;; interp. Detailed interpretation see in data definitions of listed types
#;
(define (fn-for-game g)
  (... (game-tank g)
       (game-shots g)
       (game-invaders g)))
;; Template Rules used
;; - compound: 3 fields 

  
(define-struct tank(x dx))
;; Tank is (make-tank Number Number)
;; interp. a tank at position x in pixels and speed dx
(define T1 (make-tank 50 2))
#;
(define (fn-for-tank t)
  (... (tank-x t)
       (tank-dx t)))
;; Template rules used:
;; -compound: 2 fields


(define-struct shot(x y))
;; Shot is (make-shot Number Number)
;; interp. a shot at position x y(from top border) in pixels
(define S1 (make-shot 50 50))
#;
(define (fn-for-shot s)
  (... (shot-x s)
       (shot-y s)))
;; Template rules used:
;; -compound: 2 fields


;; ListOfShots is one of:
;; - empty
;; - cons(Shot ListOfShots)
;; interp. list of shots
(define LOS1 empty)
(define LOS2 (cons (make-shot 50 50) empty))
(define LOS3 (cons (make-shot 50 50) (cons (make-shot 50 100) empty)))
#;
(define (fn-for-los los)
  (cond
    [(empty? los) (...)]
    [(... (first los)
          (fn-for-los (rest los)))]))
;; Template rules used:
;; - one of 2 cases:
;; - atomic distinct: empty
;; - compound
;; - reference Shot
;; - self-reference (rest los) is LOS


(define-struct invader(x y dx))
;; Invader is (make-invader Number Number Number Number)
;; An invader at position x y (in pixels) moving down with speed dx
(define I1 (make-invader 50 50 -3))
#;
(define (fn-for-invader i)
  (... (invader-x i)
       (invader-y i)
       (invader-dx i)))
;; Template rules used:
;; -compound: 3 fields


;; ListOfInvaders is one of:
;; - empty
;; - cons(Invader ListOfInvaders)
;; interp. list of Invaders
(define LOI1 empty)
(define LOI2 (list (make-invader 50 50 3)))
(define LOI3 (list (make-invader 50 50 3) (make-invader 50 100 -3)))
#;
(define (fn-for-loi loi)
  (cond
    [(empty? loi) (...)]
    [(... (first loi)
          (fn-for-loi (rest loi)))]))
;; Template rules used:
;; - one of 2 cases:
;; - atomic distinct: empty
;; - compound
;; - reference Invaders
;; - self-reference (rest loi) is LOI


;; =========
;; Functions


;; Main function
;; Tank moving on the background. Starts with (main (make-game (make-tank 0 3) empty empty))
(define (main g)
 (big-bang g
  [on-tick move-game]
  [to-draw render-game]
  [on-key handle-keys]
  [stop-when stop-game]))


;; Game -> Boolean
;; Stops the game when invaders get to the bottom of the game area
(define (stop-game g)
  (invaders-won? (game-invaders g)))

;; Game -> Game
;; Moves game to the next state  
;(define (move-game g) ...);stub
(define (move-game g)
  (make-game
   (move-tank (game-tank g))
   (move-shots (game-shots g))
   (hit-invaders (move-invaders (create-invaders (game-invaders g))) (game-shots g))))
  
;; Game -> Image
;; Renders image
;(define (render-game g) ...);stub
(define (render-game g)
  (render-invaders (game-invaders g)
          (render-shots (game-shots g)
                       (render-tank (game-tank g)))))


;; Game -> Game
;; Handles Key-events and changes game
(check-expect (handle-keys (make-game (make-tank 10 3) empty empty) "right") (make-game (make-tank 10 3) empty empty))
(check-expect (handle-keys (make-game (make-tank 10 -3) empty empty) "right") (make-game (make-tank 10 3) empty empty))
(check-expect (handle-keys (make-game (make-tank 10 -3) empty empty) "left") (make-game (make-tank 10 -3) empty empty))
(check-expect (handle-keys (make-game (make-tank 10 3) empty empty) "left") (make-game (make-tank 10 -3) empty empty))
(check-expect (handle-keys (make-game (make-tank 10 3) empty empty) " ") (make-game (make-tank 10 3) (list (make-shot 10 (- HEIGHT (image-height TANK)))) empty))
;(define (change-dir-tank t ke) ...);stub
(define (handle-keys g ke)
  (cond
    [(key=? ke "left") (if (> (tank-dx (game-tank g)) 0) ;; Turns tank left
                           (make-game (make-tank (tank-x (game-tank g)) (- 0 (tank-dx (game-tank g)))) (game-shots g) (game-invaders g))
                           g)]
    [(key=? ke "right") (if (< (tank-dx (game-tank g)) 0) ;; Turns tank right
                            (make-game (make-tank (tank-x (game-tank g)) (- 0 (tank-dx (game-tank g)))) (game-shots g) (game-invaders g))
                            g)]
    [(key=? ke " ") (make-game (game-tank g) (append  (list (make-shot (tank-x (game-tank g)) (- HEIGHT (image-height TANK)))) (game-shots g)) (game-invaders g))] ; Adds shot 
    [else g]))

;; Invader Image -> Image
;; Renders Invader on the given image
(check-expect (render-invader (make-invader 50 50 3) MTS) (place-image INVADER 50 50 MTS))
;(define (render-invader i img) ...);stub
(define (render-invader i img)
  (place-image INVADER (invader-x i) (invader-y i) img))


;; ListOfInvaders Image -> Image
;; Renders List of invaders on the given image
(check-expect (render-invaders empty MTS) MTS)
(check-expect (render-invaders (list (make-invader 50 50 3)) MTS) (place-image INVADER 50 50 MTS))
(check-expect (render-invaders (list (make-invader 50 50 3) (make-invader 50 150 -3)) MTS) (place-image INVADER 50 50 (place-image INVADER 50 150 MTS)))
;(define (render-invaders loi img) ...);stub 
(define (render-invaders loi img)
  (cond
    [(empty? loi) img]
    [else (render-invader (first loi)
                       (render-invaders (rest loi) img))]))


;; Shot Image -> Image
;; Renders Shot on given image
(check-expect (render-shot (make-shot 10 3) MTS) (place-image SHOT 10 3 MTS))
;(define (render-shot t) ...);stub
(define (render-shot s img)
  (place-image SHOT (shot-x s) (shot-y s) img))

;; ListOfShots -> Image
;; Renders image for lisf of shots
(define (render-shots los img)
  (cond
    [(empty? los) img]
    [else (render-shot (first los)
                       (render-shots (rest los) img))]))


;; Tank -> Tank
;; Moves tank by SPEED-TANK and changes direction (multiplies dx by -1) when tank is near the border
(check-expect (move-tank (make-tank 10 3)) (make-tank (+ 10 3) 3)) ;Normal case
(check-expect (move-tank (make-tank (- WIDTH 2) 3)) (make-tank WIDTH -3)) ; Coming to the right border
(check-expect (move-tank (make-tank 2 -3)) (make-tank 0 3)) ; Coming to the left border
(check-expect (move-tank (make-tank 10 -3)) (make-tank (+ 10 -3) -3))
;(define (move-tank t) ...);stub
(define (move-tank t)
  (cond
    [(>= (+ (tank-x t) (tank-dx t)) WIDTH) (make-tank WIDTH (* (tank-dx t) -1))]
    [(<= (+ (tank-x t) (tank-dx t)) 0) (make-tank 0 (* (tank-dx t) -1))]
    [else (make-tank (+ (tank-x t) (tank-dx t)) (tank-dx t))]))


;; Shot -> Shot
;; Moves shot with SPEED-SHOT and filters shots with shot-y < 0 and shots, that hit invaders
(check-expect (move-shot (make-shot 50 50)) (make-shot 50 (- 50 SPEED-SHOT))); normal
(check-expect (move-shot (make-shot 50 1)) (make-shot 50 (- 1 SPEED-SHOT))); close to top border of game area
;(define (move-shot s) ...);stub
(define (move-shot s)
    (make-shot (shot-x s) (- (shot-y s) SPEED-SHOT)))

;; ListOfShots -> ListOfShots
;; Moves all shots from the list
(check-expect (move-shots empty) empty)
(check-expect (move-shots (list (make-shot 0 50))) (list (make-shot 0 (- 50 SPEED-SHOT))))
(check-expect (move-shots (list (make-shot 0 0))) empty) ; removing shots out of screen
(check-expect (move-shots (list (make-shot 0 50) (make-shot 0 0))) (list (make-shot 0 (- 50 SPEED-SHOT)))) ; removing shots out of screen
(check-expect (move-shots (list (make-shot 0 0) (make-shot 0 50) )) (list (make-shot 0 (- 50 SPEED-SHOT)))) ; removing shots out of screen
;(define (move-shots los) ...);stub
(define (move-shots los)
  (cond
    [(empty? los) empty]
    [else (if (> (shot-y (first los)) 0)
              (append (list (move-shot (first los)))
                      (move-shots (rest los)))
              (move-shots (rest los)))]))


;; Invader -> Invader
;; Moves invader with SPEED-INVADER X and SPEED-INVADER-Y, changes direction when invader touches the wall
;;  and filters invader that pass bottom of the area and were hit by shot
(check-expect (move-invader (make-invader 50 0 3)) (make-invader (+ 50 3) (+ 0 SPEED-INVADER-Y) 3) ) ; moves right/down
(check-expect (move-invader (make-invader 50 0 -3)) (make-invader (+ 50 -3) (+ 0 SPEED-INVADER-Y) -3)) ; moves left/down
(check-expect (move-invader (make-invader 2 0 -3)) (make-invader 0 (+ 0 SPEED-INVADER-Y) 3)) ; changes x-direction at the left border
(check-expect (move-invader (make-invader (- WIDTH 2) 0 3)) (make-invader WIDTH (+ 0 SPEED-INVADER-Y) -3)) ; changes x-direction at the right border
;(define (move-invader s) ...);stub
(define (move-invader s)
  (cond
    [(>= (+ (invader-x s) (invader-dx s)) WIDTH) (make-invader WIDTH (+ (invader-y s) SPEED-INVADER-Y) (* (invader-dx s) -1))]
    [(<= (+ (invader-x s) (invader-dx s)) 0) (make-invader 0 (+ (invader-y s) SPEED-INVADER-Y) (* (invader-dx s) -1))]
    [else (make-invader (+ (invader-x s) (invader-dx s)) (+ (invader-y s) SPEED-INVADER-Y) (invader-dx s))]))


;; ListOfInvaders -> ListOfInvaders
;; Moves all invaders in the list
(check-expect (move-invaders empty) empty)
(check-expect (move-invaders (list (make-invader 50 0 -3))) (list (make-invader (+ 50 -3) (+ 0 SPEED-INVADER-Y) -3)))
(check-expect (move-invaders (list (make-invader 50 0 -3) (make-invader 50 50 3))) (list (make-invader (+ 50 -3) (+ 0 SPEED-INVADER-Y) -3) (make-invader (+ 50 3) (+ 50 SPEED-INVADER-Y) 3)))
;(define (move-invaders loi) ...);stub
(define (move-invaders loi)
  (cond
    [(empty? loi) empty]
    [else (append (list (move-invader (first loi)))
                      (move-invaders (rest loi)))]))

;; ListOfInvaders -> ListOfInvaders
;; Creates new invaders in random x coordinate with CREATE-INVADERS-RATE-0 CREATE-INVADERS-RATE-1 
;(define (create-invaders loi) ...);stub empty
(define (create-invaders loi)
  (cond
    [(empty? loi)
     (if (< (random 100) CREATE-INVADERS-RATE-0)
         (append loi
                 (list (make-invader (random WIDTH) 0 (if (= 0 (random 2))
                                                          (* -1 SPEED-INVADER-X)
                                                          SPEED-INVADER-X))))
         loi)]
    [else
     (if (< (random 100) CREATE-INVADERS-RATE-1)
         (append loi
                 (list (make-invader (random WIDTH) 0 (if (= 0 (random 2))
                                                          (* -1 SPEED-INVADER-X)
                                                          SPEED-INVADER-X))))
         loi)]))

;; Shot Invader -> Boolean
;; Returns true if Invader was hit by Shot. Criteria - images of Invader and Shot overlay.
(check-expect (hit? (make-shot 50 50) (make-invader 50 50 3)) true)
(check-expect (hit? (make-shot 0 0) (make-invader 100 100 3)) false)
;(define (hit? s i) ...);stub
(define (hit? s i)
    (and (and (>= (+ (shot-x s) (/ (image-width SHOT) 2)) (- (invader-x i) (/ (image-width INVADER) 2)))
             (<= (- (shot-x s) (/ (image-width SHOT) 2)) (+ (invader-x i) (/ (image-width INVADER) 2))))
         (and (>= (+ (shot-y s) (/ (image-height SHOT) 2)) (- (invader-y i) (/ (image-height INVADER) 2)))
             (<= (- (shot-y s) (/ (image-height SHOT) 2)) (+ (invader-y i) (/ (image-height INVADER) 2))))))

;; ListOfShots Invader -> Boolean
;; Checks if invader is hit by any shot on the screen
(define (hitinvader? los i)
  (cond
    [(empty? los) false]
    [else (if (hit? (first los) i) true (hitinvader? (rest los) i))]))


;; ListOfShots ListOfInvaders ->  ListOfInvaders
;; Removes shots and invaders
;(define (hit-invaders loi los) ...);stub
(define (hit-invaders loi los)
  (cond
    [(empty? loi) empty]
    [(empty? los) loi]
    [else (if (hitinvader? los (first loi))
              (hit-invaders (rest loi) los)
              (append (list (first loi)) (hit-invaders (rest loi) los)))]))       


;; ListOfInvaderes -> Boolean
;; Stops game when invaders pass bottom of the game area
(check-expect (invaders-won? empty) false)
(check-expect (invaders-won? (list (make-invader 50 HEIGHT 3))) true)
(check-expect (invaders-won? (list (make-invader 50 50 3))) false)
(check-expect (invaders-won? (list (make-invader 50 50 3) (make-invader 50 HEIGHT 3))) true)
(check-expect (invaders-won? (list (make-invader 50 HEIGHT 3) (make-invader 50 50 3))) true)
;(define (invaders-won? loi) ...);stub
(define (invaders-won? loi)
  (cond
    [(empty? loi) false]
    [else (if (>= (invader-y (first loi)) HEIGHT) true (invaders-won? (rest loi)))]))


;; Tank -> Image
;; Renders Tank on MTS
(check-expect (render-tank (make-tank 10 3)) (place-image TANK 10 (- HEIGHT (/ (image-height TANK) 2)) MTS))
;(define (render-tank t) ...);stub
(define (render-tank t)
  (place-image TANK (tank-x t) (- HEIGHT (/ (image-height TANK) 2)) MTS))


;; Space Invaders
;; Start function
(define space-invaders (main (make-game (make-tank (/ WIDTH 2) SPEED-TANK) empty empty))) 