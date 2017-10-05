rm( list=ls() )
load( file='Rdata/pars.Rdata' )
source( '../code/run_one_sim.R' )

it	<- as.numeric( commandArgs(TRUE)[[1]] )
for( type in sample( types ) )
	for( meta in sample(1:2) )
		for( fac in sample( factypes ) )
			for( K in sample( Ks ) )
{

	if( fac == 'smartsva' & meta == 1 ) next

	savefile	<-	paste0( 'Rdata/', fac, '_', meta, '_', type, '_', it, '_', K, '_test.Rdata' )
	loadfile	<-	paste0( 'Rdata/', fac, '_', meta, '_', type, '_', it, '_', K, '.Rdata' )
	if( ! file.exists( loadfile ) | file.exists( savefile ) ) next
	load( loadfile )

	sink(					paste0( 'Rout/'	, fac, '_', meta, '_', type, '_', it, '_', K, '_test.Rout' ) )
	try({
		time	<- system.time({
			out			<- run_one_sim( Y, g, Ks=K, Z=Z )
		})[3]
		cat( 'maintesttime=', time, '\n' )
		save( time, out, caus_p, file=savefile )
	})
	sink()
	rm( Z )

}
