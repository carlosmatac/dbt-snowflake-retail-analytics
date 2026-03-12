{% docs tpch_order_status %}

Indica el estado actual en el ciclo de vida del pedido. Solo puede tomar uno de los siguientes valores:

| Código | Nombre | Descripción |
| :---: | :--- | :--- |
| **O** | Open | El pedido ha sido recibido pero aún no se ha procesado por completo. |
| **P** | Pending | El pedido está retenido o pendiente de alguna validación externa. |
| **F** | Finalized | El pedido ha sido completado, facturado y/o enviado al cliente. |

*Nota: Cualquier valor fuera de esta lista hará que fallen los tests de calidad.*

{% enddocs %}