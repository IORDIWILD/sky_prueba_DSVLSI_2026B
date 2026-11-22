import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")
    
    # Configurar el reloj a 25 MHz (40 ns)
    clock = Clock(dut.clk, 40, unit="ns")
    cocotb.start_soon(clock.start())

    # Aplicar Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 10)

    dut._log.info("Test project behavior")
    
    # Simular que se presiona el botón START (ui_in[4])
    dut.ui_in.value = 16 
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 100)

    # Verificar que las salidas VGA estén generando señal (no estén en 'X' o indefinidas)
    assert dut.uo_out.value.binstr != "xxxxxxxx", "La salida VGA no está inicializada"
    
    dut._log.info("Test passed successfully!")