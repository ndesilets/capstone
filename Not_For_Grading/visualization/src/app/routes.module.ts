import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { ExperimentsComponent } from './components/experiments/experiments.component';
import { AbtcExperimentComponent } from './components/abtc-experiment/abtc-experiment.component';
import { ImcsExperimentComponent } from './components/imcs-experiment/imcs-experiment.component';
import { PgaExperimentComponent } from './components/pga-experiment/pga-experiment.component';
import { RamdiskExperimentComponent } from './components/ramdisk-experiment/ramdisk-experiment.component';
import { StatementQueuingComponent } from './components/statement-queuing/statement-queuing.component';

const routes: Routes = [
  { path : 'experiments', component: ExperimentsComponent },
  { path : 'experiments/abtc-experiment', component: AbtcExperimentComponent },
  { path : 'experiments/imcs-experiment', component: ImcsExperimentComponent },
  { path : 'experiments/pga-experiment', component: PgaExperimentComponent },
  { path : 'experiments/statement-queuing', component: StatementQueuingComponent },
  { path : 'experiments/ramdisk-experiment', component: RamdiskExperimentComponent },
  { path : '', redirectTo: '/experiments', pathMatch: 'full' }
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes)
  ],
  exports: [
    RouterModule
  ]
})
export class AppRoutingModule {}