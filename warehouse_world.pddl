(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
)

(:action startShipment
	:parameters (?s - shipment ?o - order ?l - location)
	:precondition (and (unstarted ?s) (not (complete ?s)) (available ?l) (packing-location ?l)(ships ?s ?o))
	:effect (and (started ?s) (packing-at ?s ?l) (not (available ?l))(not (unstarted ?s)))
)
(:action pickupPallette
	:parameters (?r - robot ?l - location ?p -pallette)
	:precondition (and(free ?r)(at ?p ?l)(at ?r ?l))
	:effect (and(not (free ?r))(has ?r ?p))
)
   	
(:action putdownPallette
	:parameters (?r - robot ?l - location ?p - pallette)
	:precondition (and(has ?r ?p)(not (free ?r))(at ?p ?l)(at ?r ?l))
	:effect (and(free ?r)(not (has ?r ?p)))
)

(:action robotMoveWithoutPallette
	:parameters (?r - robot ?l1 - location ?l2 - location)
	:precondition (and(free ?r)(at ?r ?l1)(no-robot ?l2)(connected ?l1 ?l2))
	:effect (and(not (at ?r ?l1))(not (no-robot ?l2))(at ?r ?l2)(no-robot ?l1))
)

(:action robotMoveWithPallette
	:parameters (?r - robot ?l1 - location ?l2 - location ?p - pallette)
	:precondition (and(has ?r ?p)(not (free ?r))(at ?r ?l1)(at ?p ?l1)(no-robot ?l2)(no-pallette ?l2)(connected ?l1 ?l2))
	:effect (and(not (at ?r ?l1))(not (at ?p ?l1))(at ?r ?l2)(at ?p ?l2)(not (no-robot ?l2))(not (no-pallette ?l2))(no-robot ?l1)(no-pallette ?l1))
)
   
   
(:action moveItemFromPalletteToShipment
	:parameters (?p - pallette ?s - shipment ?o - order ?si - saleitem ?l - location)
	:precondition (and(ships ?s ?o)(orders ?o ?si)(contains ?p ?si)(started ?s)(at ?p ?l)(packing-at ?s ?l))
	:effect (and(not (contains ?p ?si))(includes ?s ?si))
)
   
	
(:action completeShipment
	:parameters (?s -shipment ?o - order ?si -saleitem ?l - location)
	:precondition (and(ships ?s ?o)(includes ?s ?si)(orders ?o ?si))
	:effect (and(not (started ?s))(complete ?s)(available ?l)(not (packing-at ?s ?l))(not (ships ?s ?o))(not (orders ?o ?si)))
)
)