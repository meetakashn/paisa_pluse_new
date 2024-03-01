import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class InvestPlanner extends StatefulWidget {
  const InvestPlanner({super.key});

  @override
  State<InvestPlanner> createState() => _InvestPlannerState();
}

class _InvestPlannerState extends State<InvestPlanner> {
  double _investmentAmount = 500.0;
  double _value = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366),
      body: Column(
        children: [
          Text(
            'Investment Amount: \$${_investmentAmount.toString()}',
            style: TextStyle(color: Colors.white),
          ),
          Center(
            child: SfSlider(
              min: 500,
              max: 10000.0,
              activeColor: Colors.blue,
              // Change the slider active color
              inactiveColor: Colors.grey,
              value: _investmentAmount,
              interval: 2500,
              showTicks: true,
              showLabels: true,
              enableTooltip: true,
              minorTicksPerInterval: 1,
              onChanged: (dynamic newValue) {
                setState(() {
                  _investmentAmount = newValue;
                });
              },
            ),
          ),
          _buildCircularGauge(),
        ],
      ),
    );
  }

  Widget _buildCircularGauge() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 0.2,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: (_investmentAmount - 500) / (10000 - 500) * 100,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              color: Colors.green,
              enableAnimation: true,
            ),
          ],
        ),
      ],
    );
  }
}
